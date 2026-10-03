/* verb_agent.c : resident agent tasks, their mailboxes, and event routing */

#include "verb_agent.h"
#include "verb_dispatch.h"

#include "vm.h"
#include "obj.h"

#define LOG_SUBSYSTEM "verb_agent"
#include <log.h>

#include <stdio.h>
#include <string.h>

#define VA_MAX_AGENTS   64
#define VA_QUANTUM_MIN  1
#define VA_KEY_MAX      128
#define VA_PATH_MAX     1024
#define VA_MAX_RESIDENT 32
#define VA_RESPAWN_COOLDOWN 8   /* ticks between relaunch attempts, to throttle
                                 * a program that keeps dying */

/* One resident task. The manager owns the task and runs its own loop over the
 * table rather than a vm_sched, so a reap never leaves the routing tables
 * pointing at freed memory. self is the program object the task acts on; it is
 * released on reap only when the manager took the reference (a file launch),
 * not when a caller handed in its own object (an image launch). */
struct agent {
	struct vm_task *task;
	uint32_t        id;
	int             used;
	int             owns_self;
	int             listening;
	char            listen_key[VA_KEY_MAX];
	char            self_key[VA_KEY_MAX];
	char            room_id[VA_KEY_MAX];
	char            owner[VA_KEY_MAX];      /* the identity the agent runs as */
	OBJ            *self;
	struct verb_ctx ctx;
};

/* One supervised resident program. cooldown throttles relaunch attempts so a
 * program that keeps dying is retried at a bounded rate, not every tick. */
struct resident {
	int  used;
	int  cooldown;
	char prog_id[VA_KEY_MAX];
};

static struct {
	int             up;
	struct vm_env  *env;
	struct agent    a[VA_MAX_AGENTS];
	struct resident res[VA_MAX_RESIDENT];
} g_am;

/****************************************************************
 * Table helpers
 ****************************************************************/

static struct agent *
agent_by_task(const struct vm_task *t)
{
	int i;

	for (i = 0; i < VA_MAX_AGENTS; i++)
		if (g_am.a[i].used && g_am.a[i].task == t)
			return &g_am.a[i];
	return NULL;
}

static struct agent *
agent_by_id(uint32_t id)
{
	int i;

	for (i = 0; i < VA_MAX_AGENTS; i++)
		if (g_am.a[i].used && g_am.a[i].id == id)
			return &g_am.a[i];
	return NULL;
}

static struct agent *
agent_by_self_key(const char *key)
{
	int i;

	if (!key || !*key)
		return NULL;
	for (i = 0; i < VA_MAX_AGENTS; i++)
		if (g_am.a[i].used && strcmp(g_am.a[i].self_key, key) == 0)
			return &g_am.a[i];
	return NULL;
}

static struct agent *
agent_listening_on(const char *key)
{
	int i;

	if (!key || !*key)
		return NULL;
	for (i = 0; i < VA_MAX_AGENTS; i++)
		if (g_am.a[i].used && g_am.a[i].listening &&
		    strcmp(g_am.a[i].listen_key, key) == 0)
			return &g_am.a[i];
	return NULL;
}

static struct agent *
agent_alloc(void)
{
	int i;

	for (i = 0; i < VA_MAX_AGENTS; i++)
		if (!g_am.a[i].used)
			return &g_am.a[i];
	return NULL;
}

/* Free the task, drop the self reference if we own it, and clear the slot. */
static void
agent_reap(struct agent *ag)
{
	verb_handle_clear(&ag->ctx.handles);    /* release handles the agent opened */
	vm_task_free(ag->task);
	if (ag->self && ag->owns_self)
		obj_release(ag->self);
	memset(ag, 0, sizeof *ag);
}

/****************************************************************
 * Host calls (registered into the shared env)
 ****************************************************************/

/* sys_listen(): route the calling task's self-object events to it. Returns 0,
 * or -1 if the caller is not a resident agent. */
static void
hc_listen(struct vm_task *t, void *ctx)
{
	struct agent *ag = agent_by_task(t);
	(void)ctx;

	if (!ag) {
		vm_set_ret(t, (uint32_t)-1);
		return;
	}
	snprintf(ag->listen_key, sizeof ag->listen_key, "%s", ag->self_key);
	ag->listening = 1;
	vm_set_ret(t, 0);
}

/* sys_notify(key_ptr, str_ptr): deliver a user event carrying a string to the
 * agent listening on the named object. Returns 0, or -1 if no one listens or
 * the target mailbox is full. */
static void
hc_notify(struct vm_task *t, void *ctx)
{
	char key[VA_KEY_MAX], str[VA_PATH_MAX];
	uint32_t len;
	(void)ctx;

	vm_arg_cstr(t, vm_arg(t, 0), key, sizeof key);
	len = vm_arg_cstr(t, vm_arg(t, 1), str, sizeof str);
	vm_set_ret(t, (uint32_t)verb_agent_deliver(key, VM_EV_USER,
	                                           vm_task_id(t), str, len));
}

/* sys_post(taskid): wake a task by id with a bare event. Returns 0, or -1. */
static void
hc_post(struct vm_task *t, void *ctx)
{
	(void)ctx;
	vm_set_ret(t, (uint32_t)verb_agent_post(vm_arg(t, 0), VM_EV_WAKE,
	                                        vm_task_id(t), NULL, 0));
}

/* sys_taskid(): the calling task's id. */
static void
hc_taskid(struct vm_task *t, void *ctx)
{
	(void)ctx;
	vm_set_ret(t, vm_task_id(t));
}

/****************************************************************
 * Lifecycle
 ****************************************************************/

int
verb_agent_init(struct vm_env *env)
{
	if (g_am.up)
		return 0;
	if (!env)
		return -1;
	if (vm_env_register(env, "sys_listen", hc_listen, NULL) != 0 ||
	    vm_env_register(env, "sys_notify", hc_notify, NULL) != 0 ||
	    vm_env_register(env, "sys_post", hc_post, NULL) != 0 ||
	    vm_env_register(env, "sys_taskid", hc_taskid, NULL) != 0)
		return -1;
	g_am.env = env;
	g_am.up = 1;
	return 0;
}

void
verb_agent_shutdown(void)
{
	int i;

	for (i = 0; i < VA_MAX_AGENTS; i++)
		if (g_am.a[i].used)
			agent_reap(&g_am.a[i]);
	memset(g_am.res, 0, sizeof g_am.res);
	g_am.env = NULL;
	g_am.up = 0;
}

/* Fill a fresh slot for a loaded task and wire its context and output. An agent
 * runs as its self object's owner, so a self with no %owner cannot be launched;
 * on refusal this frees the task (and releases self when owned) and returns 0.
 * The caller treats 0 as a failed launch. */
static uint32_t
agent_start(struct agent *ag, struct vm_task *t, OBJ *self, int owns_self,
            const char *self_key, const char *room_id)
{
	const char *owner = self ? obj_prop_get(self, "%owner") : NULL;

	if (!owner || !*owner) {
		LOG_ERROR("agent self '%s' has no %%owner; not launched",
			self_key ? self_key : "?");
		vm_task_free(t);
		if (self && owns_self)
			obj_release(self);
		return 0;
	}

	ag->task = t;
	ag->id = vm_task_id(t);
	ag->self = self;
	ag->owns_self = owns_self;
	ag->listening = 0;
	snprintf(ag->self_key, sizeof ag->self_key, "%s", self_key ? self_key : "");
	snprintf(ag->room_id, sizeof ag->room_id, "%s", room_id ? room_id : "");
	snprintf(ag->owner, sizeof ag->owner, "%s", owner);
	ag->listen_key[0] = 0;

	ag->ctx.self = self;
	ag->ctx.self_key = ag->self_key;
	ag->ctx.room_id = ag->room_id;
	/* The agent acts as its object's owner. It has no caller, so actor_id
	 * stays NULL; sys_setpriv AS_CALLER falls back to real_owner. */
	ag->ctx.actor_id = NULL;
	ag->ctx.eff_owner = ag->owner;
	ag->ctx.real_owner = ag->owner;
	ag->ctx.wiz_available = verb_dispatch_may_wizard(ag->owner);
	ag->ctx.is_wizard = 0;
	verb_handle_set_self(&ag->ctx.handles, self);
	ag->used = 1;

	vm_task_set_userdata(t, &ag->ctx);
	vm_task_set_output(t, verb_out_to_room, ag->room_id);
	return ag->id;
}

uint32_t
verb_agent_launch(const char *prog_id, const char *room_id)
{
	char full[VA_PATH_MAX];
	char key[VA_KEY_MAX];
	uint32_t ram = 0;
	struct agent *ag;
	struct vm_task *t;
	OBJ *self;
	const char *room;

	if (!g_am.up || !prog_id)
		return 0;
	if (verb_program_resolve(prog_id, full, sizeof full, &ram) != 0)
		return 0;
	ag = agent_alloc();
	if (!ag)
		return 0;

	snprintf(key, sizeof key, "programs/%s", prog_id);
	self = obj_get(key);
	if (!self)
		return 0;

	t = vm_task_new(ram);
	if (!t) {
		obj_release(self);
		return 0;
	}
	vm_task_set_env(t, g_am.env);
	if (vm_task_load_file(t, full) != 0) {
		vm_task_free(t);
		obj_release(self);
		return 0;
	}
	/* Default the broadcast room to the program object's own "room" property. */
	room = room_id ? room_id : obj_prop_get(self, "room");
	return agent_start(ag, t, self, 1, key, room);
}

uint32_t
verb_agent_launch_image(const uint8_t *elf, long len, OBJ *self,
                        const char *self_key, const char *room_id)
{
	struct agent *ag;
	struct vm_task *t;

	if (!g_am.up)
		return 0;
	ag = agent_alloc();
	if (!ag)
		return 0;
	t = vm_task_new(0);
	if (!t)
		return 0;
	vm_task_set_env(t, g_am.env);
	if (vm_task_load_mem(t, elf, len, "<agent>") != 0) {
		vm_task_free(t);
		return 0;
	}
	return agent_start(ag, t, self, 0, self_key, room_id);
}

int
verb_agent_tick(int quantum)
{
	int i, live = 0;

	if (quantum < VA_QUANTUM_MIN)
		quantum = VA_QUANTUM_MIN;
	for (i = 0; i < VA_MAX_AGENTS; i++) {
		struct agent *ag = &g_am.a[i];
		enum vm_state st;

		if (!ag->used)
			continue;
		st = vm_task_run(ag->task, quantum);
		if (st == VM_EXITED || st == VM_FAULTED)
			agent_reap(ag);
		else
			live++;
	}
	return live;
}

int
verb_agent_deliver(const char *listen_key, uint32_t kind, uint32_t sender,
                   const char *str, uint32_t len)
{
	struct agent *ag = agent_listening_on(listen_key);

	if (!ag)
		return -1;
	return vm_task_post(ag->task, kind, sender, str, len);
}

int
verb_agent_post(uint32_t taskid, uint32_t kind, uint32_t sender,
                const char *str, uint32_t len)
{
	struct agent *ag = agent_by_id(taskid);

	if (!ag)
		return -1;
	return vm_task_post(ag->task, kind, sender, str, len);
}

int
verb_agent_count(void)
{
	int i, n = 0;

	for (i = 0; i < VA_MAX_AGENTS; i++)
		if (g_am.a[i].used)
			n++;
	return n;
}

/****************************************************************
 * Resident supervision
 ****************************************************************/

void
verb_agent_set_resident(const char *csv)
{
	const char *p;
	int n = 0;

	memset(g_am.res, 0, sizeof g_am.res);
	if (!csv)
		return;

	p = csv;
	while (*p && n < VA_MAX_RESIDENT) {
		const char *end;
		size_t k = 0;

		while (*p == ' ' || *p == ',')         /* skip separators and spaces */
			p++;
		if (!*p)
			break;
		end = p;
		while (*end && *end != ',')             /* one id */
			end++;
		while (end > p && end[-1] == ' ')       /* trim trailing spaces */
			end--;
		while (p < end && k + 1 < VA_KEY_MAX)
			g_am.res[n].prog_id[k++] = *p++;
		g_am.res[n].prog_id[k] = 0;
		if (k > 0) {
			g_am.res[n].used = 1;
			g_am.res[n].cooldown = 0;
			n++;
		}
		p = end;
	}
}

int
verb_agent_supervise(void)
{
	char key[VA_KEY_MAX];
	int i, attempts = 0;

	if (!g_am.up)
		return 0;
	for (i = 0; i < VA_MAX_RESIDENT; i++) {
		struct resident *r = &g_am.res[i];

		if (!r->used)
			continue;
		if (r->cooldown > 0) {
			r->cooldown--;
			continue;
		}
		snprintf(key, sizeof key, "programs/%s", r->prog_id);
		if (agent_by_self_key(key))
			continue;                       /* already running */
		/* Launch (or relaunch) and throttle the next attempt whether it
		 * succeeded or the program died at once, so a broken resident cannot
		 * spin the tick. */
		verb_agent_launch(r->prog_id, NULL);
		r->cooldown = VA_RESPAWN_COOLDOWN;
		attempts++;
	}
	return attempts;
}
