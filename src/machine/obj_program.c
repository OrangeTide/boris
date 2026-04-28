#define LOG_SUBSYSTEM "obj_program"
#include <log.h>

#include "obj_program.h"
#include "machine.h"
#include "program.h"
#include "telnetclient.h"
#include <boris.h>
#include <obj.h>

#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <iox_timer.h>

#define TICK_INTERVAL_MS 1000
#define MAX_INSNS_PER_TICK 4096

struct obj_task {
	struct obj_task   *next;
	char              *obj_id;
	char              *interface;
	machine_t         *task;
	int                sleep_remaining;
};

static struct obj_task  *task_list;
static struct iox_loop  *g_loop;
static int               tick_timer = -1;

static void
msg_cb(void *ctx, const char *buf, size_t len)
{
	struct obj_task *ot = ctx;
	char line[512];

	if (len >= sizeof(line))
		len = sizeof(line) - 1;
	memcpy(line, buf, len);
	line[len] = '\0';
	telnetclient_room_broadcast(ot->obj_id, line);
}

/****************************************************************
 * Interface checking
 ****************************************************************/

static const char *exit_iface_verbs[] = { "go", "look", NULL };

static const struct {
	const char  *name;
	const char **verbs;
} interface_defs[] = {
	{ "exit", exit_iface_verbs },
};

#define NR_IFACE_DEFS (sizeof(interface_defs) / sizeof(interface_defs[0]))

static void
check_one_interface(const char *obj_id, machine_t *task,
                    const char *name)
{
	unsigned i;
	const char **v;

	for (i = 0; i < NR_IFACE_DEFS; i++) {
		if (strcmp(interface_defs[i].name, name) == 0)
			break;
	}

	if (i == NR_IFACE_DEFS) {
		LOG_WARNING("%s: unknown interface \"%s\"",
		            obj_id, name);
		return;
	}

	for (v = interface_defs[i].verbs; *v; v++) {
		if (machine_find_verb(task, *v) < 0)
			LOG_WARNING("%s: interface \"%s\""
			            " missing verb \"%s\"",
			            obj_id, name, *v);
	}
}

static void
check_interfaces(const char *obj_id, machine_t *task,
                 const char *iface_list)
{
	char buf[256];
	const char *p, *end;
	size_t len;

	if (!iface_list)
		return;

	p = iface_list;
	while (*p) {
		while (*p == ' ' || *p == ',')
			p++;
		if (!*p)
			break;
		end = p;
		while (*end && *end != ',')
			end++;
		len = (size_t)(end - p);
		while (len > 0 && p[len - 1] == ' ')
			len--;
		if (len == 0) {
			p = end;
			continue;
		}
		if (len >= sizeof(buf))
			len = sizeof(buf) - 1;
		memcpy(buf, p, len);
		buf[len] = '\0';
		check_one_interface(obj_id, task, buf);
		p = end;
	}
}

/****************************************************************
 * Tick timer
 ****************************************************************/

static void
tick_cb(struct iox_loop *loop, void *arg)
{
	struct obj_task *ot;

	(void)arg;

	for (ot = task_list; ot; ot = ot->next) {
		machine_state_t st = machine_state(ot->task);

		if (st == MACHINE_SLEEPING) {
			ot->sleep_remaining -= TICK_INTERVAL_MS;
			if (ot->sleep_remaining <= 0) {
				machine_wake(ot->task);
				st = machine_state(ot->task);
			}
		}

		if (st == MACHINE_INIT || st == MACHINE_BUSY) {
			machine_run_result_t rc;
			rc = machine_run(ot->task, MAX_INSNS_PER_TICK);
			if (rc == MACHINE_RUN_SLEEP) {
				ot->sleep_remaining =
				    (int)machine_sleep_ms(ot->task);
			} else if (rc == MACHINE_RUN_READY) {
				LOG_INFO("%s: machine ready", ot->obj_id);
				check_interfaces(ot->obj_id, ot->task,
				                 ot->interface);
			} else if (rc == MACHINE_RUN_EXIT) {
				LOG_INFO("%s: machine exited with %d",
				         ot->obj_id,
				         machine_exit_status(ot->task));
			}
		}
	}

	tick_timer = iox_timer_add(loop, TICK_INTERVAL_MS, tick_cb, NULL);
}

#define TERM_MAX_INSNS 8192

static void
obj_program_detach(const char *obj_id)
{
	struct obj_task **pp, *ot;
	const char *how = "detached";

	for (pp = &task_list; *pp; pp = &(*pp)->next) {
		if (strcmp((*pp)->obj_id, obj_id) == 0) {
			ot = *pp;
			*pp = ot->next;

			if (machine_state(ot->task) == MACHINE_READY) {
				int efd = machine_find_event(ot->task,
				                                  "term");
				if (efd >= 0 &&
				    machine_dispatch(ot->task, efd) == 0) {
					machine_run(ot->task,
					                 TERM_MAX_INSNS);
					if (machine_state(ot->task) ==
					    MACHINE_DEAD)
						how = "clean shutdown";
					else
						how = "force-killed";
				}
			}

			LOG_INFO("%s: machine %s", obj_id, how);
			machine_free(ot->task);
			free(ot->interface);
			free(ot->obj_id);
			free(ot);
			return;
		}
	}
}

static void
on_obj_load(OBJ *o, const char *id, void *arg)
{
	const char *prog_id, *iface;
	unsigned ram_size;
	OBJ *prog;
	int image_fd;

	(void)arg;

	prog_id = obj_prop_get(o, "program.continuous");
	if (!prog_id)
		return;

	prog = program_get(prog_id);
	if (!prog)
		return;

	image_fd = program_open_image(prog);
	if (image_fd < 0) {
		LOG_WARNING("%s: program %s: cannot open image",
		            id, prog_id);
		program_release(prog);
		return;
	}

	ram_size = program_ram_size(prog);
	iface = program_interface(prog);
	obj_program_attach(id, image_fd, prog_id,
	                   ram_size, iface);
	close(image_fd);
	program_release(prog);
}

static void
on_obj_evict(OBJ *o, const char *id, void *arg)
{
	(void)o;
	(void)arg;

	obj_program_detach(id);
}

int
obj_program_init(struct iox_loop *loop)
{
	g_loop = loop;
	task_list = NULL;
	tick_timer = iox_timer_add(loop, TICK_INTERVAL_MS, tick_cb, NULL);
	if (tick_timer < 0)
		return -1;

	obj_set_load_cb(on_obj_load, NULL);
	obj_set_evict_cb(on_obj_evict, NULL);

	return 0;
}

void
obj_program_shutdown(void)
{
	struct obj_task *ot, *next;

	if (g_loop && tick_timer >= 0) {
		iox_timer_remove(g_loop, tick_timer);
		tick_timer = -1;
	}

	for (ot = task_list; ot; ot = next) {
		next = ot->next;
		machine_free(ot->task);
		free(ot->interface);
		free(ot->obj_id);
		free(ot);
	}
	task_list = NULL;
}

int
obj_program_attach(const char *obj_id, int image_fd,
                   const char *prog_id,
                   unsigned ram_size, const char *interface)
{
	struct obj_task *ot;
	machine_t *t;
	int entry;

	t = machine_new(ram_size);
	if (!t)
		return -1;

	ot = calloc(1, sizeof(*ot));
	if (!ot) {
		machine_free(t);
		return -1;
	}

	ot->obj_id = strdup(obj_id);
	if (!ot->obj_id) {
		machine_free(t);
		free(ot);
		return -1;
	}

	ot->interface = interface ? strdup(interface) : NULL;
	ot->task = t;

	machine_fd_open(t, 1, msg_cb, ot);

	entry = machine_load_elf_fd(t, image_fd, prog_id);
	if (entry < 0) {
		machine_free(t);
		free(ot->interface);
		free(ot->obj_id);
		free(ot);
		return -1;
	}

	if (machine_start(t, (uint32_t)entry, ram_size) < 0) {
		machine_free(t);
		free(ot->interface);
		free(ot->obj_id);
		free(ot);
		return -1;
	}

	ot->next = task_list;
	task_list = ot;

	LOG_INFO("attached machine to %s (program=%s entry=0x%x)",
	         obj_id, prog_id, (unsigned)entry);
	return 0;
}

#define DISPATCH_MAX_INSNS 8192

int
obj_program_dispatch_verb(const char *obj_id, const char *verb,
                          const char *player_id, const char *direction)
{
	struct obj_task *ot;
	int fd;

	for (ot = task_list; ot; ot = ot->next) {
		if (strcmp(ot->obj_id, obj_id) == 0)
			break;
	}
	if (!ot)
		return -1;

	if (machine_state(ot->task) != MACHINE_READY)
		return -1;

	fd = machine_find_verb(ot->task, verb);
	if (fd < 0)
		return -1;

	machine_write_context(ot->task, fd, verb, obj_id,
	                      player_id, direction);

	if (machine_dispatch(ot->task, fd) < 0)
		return -1;

	machine_run(ot->task, DISPATCH_MAX_INSNS);
	return 0;
}
