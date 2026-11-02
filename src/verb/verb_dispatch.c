/* verb_dispatch.c : one-shot dispatch of guest programs against game objects */

#include "verb_dispatch.h"
#include "verb_agent.h"

#include "vm.h"
#include "obj.h"
#include "resolve.h"
#include "verb_model.h"
#include "verb_spec.h"
#include "vfs.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define VD_QUANTUM      8192    /* instructions per scheduling slice */
#define VD_MAX_SLICES   64      /* run cap is VD_QUANTUM * VD_MAX_SLICES */
#define VD_LINE_MAX     512
#define VD_DIR_MAX      256     /* image directory and relative image path */
#define VD_PATH_MAX     1024    /* joined dir + image path */
#define VD_NAME_MAX     128
#define VD_VALUE_MAX    256

/* Typed-argument slot tags, in lockstep with sdk/vm/include/cmd.h
 * (CMD_ARG_OBJ / CMD_ARG_STR). The host builds the slots; the guest runtime
 * reads them. */
#define VERB_ARG_OBJ    1u
#define VERB_ARG_STR    2u

static struct vm_env    *g_env;
static verb_broadcast_fn g_bcast;
static char              g_image_dir[VD_DIR_MAX];
static int             (*g_may_wizard)(const char *owner_id);
static int               g_create_max;   /* per-task sys_create cap; 0 = unlimited */
static int               g_owned_max;    /* per-owner object cap; 0 = unlimited */
static struct vfs       *g_vfs;          /* in-world VFS for host-side tools; may be NULL */

#define VD_MAX_FG       32      /* concurrent foreground interactive sessions */

/* The 9P mount name a launched program reaches the in-world VFS through, and
 * the host directory passed with it. boris's p9 server ignores the directory
 * (it serves the bound VFS), but the launcher opens it to validate the grant,
 * so it must be a real, readable directory; the image directory is both and is
 * already permitted under the security sandbox. */
#define VD_WORLD_MOUNT  "world"

/* One foreground interactive session: a long-lived task bound to a player's
 * descriptor through the host's output/exit hooks. Unlike a one-shot it keeps
 * its verb_ctx and self reference alive for its whole life, so the authority
 * strings the ctx points at are copied into the session rather than borrowed
 * from a caller's stack. */
struct verb_fg {
	int               used;
	uint32_t          id;             /* the task id, used to feed and quit */
	int               quitting;       /* stdin closed; kill if still live next tick */
	struct vm_task   *task;
	OBJ              *self;           /* pinned; released on reap */
	struct verb_ctx   ctx;
	char              actor[OBJ_PATH_MAX];       /* ctx.actor_id / eff_owner */
	char              room[OBJ_PATH_MAX];        /* ctx.room_id (output location) */
	char              real_owner[OBJ_PATH_MAX];  /* ctx.real_owner */
	verb_fg_output_fn out;
	verb_fg_exit_fn   on_exit;
	void             *hook_ctx;
};
static struct verb_fg g_fg[VD_MAX_FG];
static void fg_reap(struct verb_fg *s);

/* sys_setpriv modes, in lockstep with sdk/vm/include/vmsys.h (VM_PRIV_*). */
#define VERB_PRIV_WIZ_ON    1u   /* enable wizard (if available) */
#define VERB_PRIV_WIZ_OFF   2u   /* drop wizard */
#define VERB_PRIV_AS_OWNER  3u   /* effective owner -> the object's %owner */
#define VERB_PRIV_AS_CALLER 4u   /* effective owner -> the command initiator */

/* Failure codes reported by sys_errno, in lockstep with sdk/vm/include/vmsys.h
 * (VM_ERR_*). A call records one of these when it signals failure. */
#define VERB_ERR_NONE      0
#define VERB_ERR_DENIED    1     /* authority: not the owner and not wizard */
#define VERB_ERR_NOTFOUND  2     /* no such object / name / property */
#define VERB_ERR_AMBIGUOUS 3     /* a name matched more than one object */
#define VERB_ERR_EXISTS    4     /* create: the id is already in use */
#define VERB_ERR_INVAL     5     /* bad argument: handle, id, mode, or move */
#define VERB_ERR_NOSPACE   6     /* the handle table is full */
#define VERB_ERR_NOTEMPTY  7     /* recycle: the container still has members */

/* Record a failing call's reason for the next sys_errno. */
static void
verb_seterr(struct verb_ctx *vc, int code)
{
	if (vc)
		vc->last_error = code;
}

/* Whether `id`'s account may enable wizard. Deny when no check is registered. */
static int
authority_may_wizard(const char *id)
{
	return id && g_may_wizard && g_may_wizard(id);
}

/* Switch the task's effective owner, recomputing its wizard availability and
 * dropping any enabled wizard: an identity change starts un-elevated, and the
 * new identity must be permitted before it can elevate again.
 *
 * wiz_available is a snapshot taken here, so a durable 'w' revoked on the
 * account mid-task is not observed until the next identity switch. Tasks are
 * short-lived one-shots, so this staleness window is accepted. */
static void
authority_set_owner(struct verb_ctx *vc, const char *id)
{
	vc->eff_owner = id;
	vc->wiz_available = authority_may_wizard(id);
	vc->is_wizard = 0;
}

/****************************************************************
 * Host calls (registered into g_env)
 ****************************************************************/

/* sys_getprop(obj, name_ptr, buf_ptr, buf_len): copy the string property `name`
 * of the handle object into the guest buffer, returning the length written (0
 * when the handle or property is absent). Pass VM_HANDLE_SELF for self.
 *
 * Reads are intentionally unfiltered: unlike the write path (sys_setprop, which
 * refuses `%`/`!` names), a guest may read internal structural fields such as
 * %owner, %parent, and %location. These are not treated as confidential. If a
 * `%`/`!` field ever needs to be hidden from guests, filter it here. */
static void
hc_getprop(struct vm_task *t, void *ctx)
{
	struct verb_ctx *vc = vm_task_userdata(t);
	char name[VD_NAME_MAX];
	const char *val;
	OBJ *o;
	uint32_t len, cap;
	(void)ctx;

	o = vc ? verb_handle_get(&vc->handles, vm_arg(t, 0)) : NULL;
	vm_arg_cstr(t, vm_arg(t, 1), name, sizeof name);
	val = o ? obj_prop_get(o, name) : NULL;
	if (!val) {
		vm_set_ret(t, 0);
		return;
	}
	len = (uint32_t)strlen(val);
	cap = vm_arg(t, 3);
	if (len > cap)
		len = cap;
	vm_set_ret(t, vm_write(t, vm_arg(t, 2), val, len));
}

/* Whether the task may modify (write/move/recycle) object o. Allowed when the
 * task is wizard-enabled, when it is a host-initiated (system) task with no
 * effective owner, or when its effective owner matches o's %owner. An object
 * with no %owner is modifiable only by a wizard or the system. */
static int
verb_may_modify(struct verb_ctx *vc, OBJ *o)
{
	const char *owner;

	if (!vc || vc->is_wizard || !vc->eff_owner)
		return 1;
	owner = o ? obj_prop_get(o, "%owner") : NULL;
	return owner && strcmp(owner, vc->eff_owner) == 0;
}

/* sys_setprop(obj, name_ptr, val_ptr): set the string property `name` on the
 * handle object. Returns 0 on success, -1 on a bad handle or when the task's
 * authority does not own the object (and is not wizard). */
static void
hc_setprop(struct vm_task *t, void *ctx)
{
	struct verb_ctx *vc = vm_task_userdata(t);
	char name[VD_NAME_MAX], val[VD_VALUE_MAX];
	OBJ *o;
	(void)ctx;

	o = vc ? verb_handle_get(&vc->handles, vm_arg(t, 0)) : NULL;
	if (!o) {
		verb_seterr(vc, VERB_ERR_INVAL);
		vm_set_ret(t, (uint32_t)-1);
		return;
	}
	if (!verb_may_modify(vc, o)) {
		verb_seterr(vc, VERB_ERR_DENIED);
		vm_set_ret(t, (uint32_t)-1);
		return;
	}
	vm_arg_cstr(t, vm_arg(t, 1), name, sizeof name);
	vm_arg_cstr(t, vm_arg(t, 2), val, sizeof val);
	if (obj_prop_set(o, name, val) != 0) {
		verb_seterr(vc, VERB_ERR_INVAL);
		vm_set_ret(t, (uint32_t)-1);
		return;
	}
	vm_set_ret(t, 0);
}

/* sys_close(obj): release a handle the program no longer needs. The self and
 * none handles are not closable. Always returns 0. */
static void
hc_close(struct vm_task *t, void *ctx)
{
	struct verb_ctx *vc = vm_task_userdata(t);
	(void)ctx;

	if (vc)
		verb_handle_close(&vc->handles, vm_arg(t, 0));
	vm_set_ret(t, 0);
}

/* Add obj (a fresh obj_get reference) to the task's handle table and return the
 * new handle. On a full table, release the reference and return 0. */
static uint32_t
handle_or_release(struct verb_ctx *vc, OBJ *obj)
{
	unsigned h = verb_handle_add(&vc->handles, obj);

	if (h == VERB_HANDLE_NONE) {
		obj_release(obj);
		verb_seterr(vc, VERB_ERR_NOSPACE);
		return 0;
	}
	return h;
}

/* sys_getobj(obj, name_ptr): read the string property `name` of the handle
 * object as an object id, and return a new handle to that object. Returns 0 if
 * the property is absent or the referenced object cannot be loaded. */
static void
hc_getobj(struct vm_task *t, void *ctx)
{
	struct verb_ctx *vc = vm_task_userdata(t);
	char name[VD_NAME_MAX], ref[OBJ_PATH_MAX];
	const char *val;
	OBJ *src, *o;
	(void)ctx;

	src = vc ? verb_handle_get(&vc->handles, vm_arg(t, 0)) : NULL;
	vm_arg_cstr(t, vm_arg(t, 1), name, sizeof name);
	val = src ? obj_prop_get(src, name) : NULL;
	if (!val || !*val) {
		verb_seterr(vc, VERB_ERR_NOTFOUND);
		vm_set_ret(t, 0);
		return;
	}
	snprintf(ref, sizeof ref, "%s", val);   /* copy before obj_get */
	o = obj_get(ref);
	if (!o) {
		verb_seterr(vc, VERB_ERR_NOTFOUND);
		vm_set_ret(t, 0);
		return;
	}
	vm_set_ret(t, handle_or_release(vc, o));
}

/* sys_objfind(name_ptr, players_only): resolve a name in the task's actor scope
 * to a new object handle, or 0 when there is no unique match. On a miss
 * sys_errno distinguishes a name that matched nothing (VM_ERR_NOTFOUND) from one
 * that matched several objects (VM_ERR_AMBIGUOUS). The actor is the task's
 * actor_id, or its self object when that is unset. */
static void
hc_objfind(struct vm_task *t, void *ctx)
{
	struct verb_ctx *vc = vm_task_userdata(t);
	char name[VD_NAME_MAX], id[OBJ_PATH_MAX];
	const char *actor;
	OBJ *o;
	(void)ctx;

	if (!vc) {
		vm_set_ret(t, 0);
		return;
	}
	actor = vc->actor_id ? vc->actor_id
	      : (vc->self ? obj_key(vc->self) : NULL);
	if (!actor) {
		verb_seterr(vc, VERB_ERR_NOTFOUND);
		vm_set_ret(t, 0);
		return;
	}
	vm_arg_cstr(t, vm_arg(t, 0), name, sizeof name);
	switch (resolve_name(actor, name, (int)vm_arg(t, 1), id, sizeof id)) {
	case RESOLVE_OK:
		break;
	case RESOLVE_AMBIGUOUS:
		verb_seterr(vc, VERB_ERR_AMBIGUOUS);
		vm_set_ret(t, 0);
		return;
	default:
		verb_seterr(vc, VERB_ERR_NOTFOUND);
		vm_set_ret(t, 0);
		return;
	}
	o = obj_get(id);
	if (!o) {
		verb_seterr(vc, VERB_ERR_NOTFOUND);
		vm_set_ret(t, 0);
		return;
	}
	vm_set_ret(t, handle_or_release(vc, o));
}

/* sys_next(container, ordinal): return a new handle to the ordinal-th member of
 * the container, or 0 past the end. Linear in ordinal; a program iterating a
 * large container should sys_close each handle it is done with so the table
 * does not fill. */
static void
hc_next(struct vm_task *t, void *ctx)
{
	struct verb_ctx *vc = vm_task_userdata(t);
	OBJ *container, *o;
	const char *cid, *member = NULL;
	OBJ_CONTENTS_ITER *it;
	char id[OBJ_PATH_MAX];
	uint32_t ordinal, i;
	(void)ctx;

	container = vc ? verb_handle_get(&vc->handles, vm_arg(t, 0)) : NULL;
	cid = container ? obj_key(container) : NULL;
	it = cid ? obj_contents_begin(cid) : NULL;
	if (!it) {
		verb_seterr(vc, VERB_ERR_INVAL);        /* bad container handle */
		vm_set_ret(t, 0);
		return;
	}
	ordinal = vm_arg(t, 1);
	for (i = 0; i <= ordinal; i++) {
		member = obj_contents_next(it);
		if (!member)
			break;
	}
	if (member)
		snprintf(id, sizeof id, "%s", member);  /* copy before end frees it */
	obj_contents_end(it);
	if (!member) {
		vm_set_ret(t, 0);               /* past the end: not an error */
		return;
	}
	o = obj_get(id);
	if (!o) {
		verb_seterr(vc, VERB_ERR_NOTFOUND);     /* indexed but unloadable */
		vm_set_ret(t, 0);
		return;
	}
	vm_set_ret(t, handle_or_release(vc, o));
}

/* sys_move(member, container): relocate the member object into the container,
 * or to limbo when container is the none handle. Returns 0 on success, -1 on a
 * bad handle, a move the task's authority may not make (it does not own the
 * member and is not wizard), or a move obj_move refuses (a cycle).
 *
 * By design the authority check is on the member only, not the destination: a
 * task that owns an object may place it into any container it holds a handle to,
 * regardless of who owns that container. There is deliberately no
 * "destination accepts this" gate. */
static void
hc_move(struct vm_task *t, void *ctx)
{
	struct verb_ctx *vc = vm_task_userdata(t);
	OBJ *member, *container;
	const char *mkey, *ckey;
	uint32_t chandle;
	(void)ctx;

	member = vc ? verb_handle_get(&vc->handles, vm_arg(t, 0)) : NULL;
	mkey = member ? obj_key(member) : NULL;
	if (!mkey) {
		verb_seterr(vc, VERB_ERR_INVAL);
		vm_set_ret(t, (uint32_t)-1);
		return;
	}
	if (!verb_may_modify(vc, member)) {
		verb_seterr(vc, VERB_ERR_DENIED);
		vm_set_ret(t, (uint32_t)-1);
		return;
	}
	chandle = vm_arg(t, 1);
	if (chandle == VERB_HANDLE_NONE) {
		ckey = NULL;                    /* move to limbo */
	} else {
		container = verb_handle_get(&vc->handles, chandle);
		ckey = container ? obj_key(container) : NULL;
		if (!ckey) {
			verb_seterr(vc, VERB_ERR_INVAL);
			vm_set_ret(t, (uint32_t)-1);
			return;
		}
	}
	if (obj_move(mkey, ckey) != OBJ_OK) {
		verb_seterr(vc, VERB_ERR_INVAL);        /* e.g. a containment cycle */
		vm_set_ret(t, (uint32_t)-1);
		return;
	}
	vm_set_ret(t, 0);
}

/* sys_setpriv(mode): adjust the task's authority, seteuid-style. WIZ_ON enables
 * wizard when the current effective identity is permitted (else -1); WIZ_OFF
 * drops it. AS_OWNER switches the effective owner to the attached object's
 * %owner (the real identity the program may assume) and AS_CALLER back to the
 * initiator; either switch drops wizard. Returns 0, or -1 on a denied elevation
 * or an owner switch with no identity to assume. */
static void
hc_setpriv(struct vm_task *t, void *ctx)
{
	struct verb_ctx *vc = vm_task_userdata(t);
	uint32_t mode;
	(void)ctx;

	if (!vc) {
		vm_set_ret(t, (uint32_t)-1);
		return;
	}
	mode = vm_arg(t, 0);
	switch (mode) {
	case VERB_PRIV_WIZ_ON:
		if (!vc->wiz_available) {
			verb_seterr(vc, VERB_ERR_DENIED);
			vm_set_ret(t, (uint32_t)-1);
			return;
		}
		vc->is_wizard = 1;
		break;
	case VERB_PRIV_WIZ_OFF:
		vc->is_wizard = 0;
		break;
	case VERB_PRIV_AS_OWNER:
		if (!vc->real_owner) {
			verb_seterr(vc, VERB_ERR_INVAL);
			vm_set_ret(t, (uint32_t)-1);
			return;
		}
		authority_set_owner(vc, vc->real_owner);
		break;
	case VERB_PRIV_AS_CALLER:
		/* For a verb this is the initiator. An agent has no caller, so it
		 * resets to its own launch identity (real_owner) rather than to a
		 * NULL owner, which would drop it to unrestricted system. */
		authority_set_owner(vc, vc->actor_id ? vc->actor_id : vc->real_owner);
		break;
	default:
		verb_seterr(vc, VERB_ERR_INVAL);
		vm_set_ret(t, (uint32_t)-1);
		return;
	}
	vm_set_ret(t, 0);
}

/* A guest may name a created object anywhere except the system namespaces, and
 * the id must be structurally safe (non-empty, relative, no parent traversal,
 * not a property-name sigil). This is the fence for guest-supplied ids. */
static int
verb_create_id_ok(const char *id)
{
	static const char *const reserved[] = {
		"programs/", "chars/", "rooms/", "templates/",
	};
	size_t i;

	if (!id || !*id || id[0] == '/' || id[0] == '%' || id[0] == '!')
		return 0;
	if (strstr(id, ".."))
		return 0;
	for (i = 0; i < sizeof reserved / sizeof reserved[0]; i++)
		if (strncmp(id, reserved[i], strlen(reserved[i])) == 0)
			return 0;
	return 1;
}

/* sys_create(parent, id_ptr): create a new persistent object with the
 * guest-supplied id, owned by the task's effective owner and parented to the
 * handle object (VM_HANDLE_NONE for none). Returns a new handle, or
 * VM_HANDLE_NONE when the id is reserved or malformed, the per-task or
 * per-owner creation quota is reached, it already exists, the parent handle is
 * bad, or the table is full. The quotas apply only to a task that acts as an
 * owner; system and agent tasks (no effective owner) are trusted and exempt. */
static void
hc_create(struct vm_task *t, void *ctx)
{
	struct verb_ctx *vc = vm_task_userdata(t);
	char id[OBJ_PATH_MAX];
	const char *pkey = NULL;
	OBJ *o;
	uint32_t phandle, h;
	(void)ctx;

	if (!vc) {
		vm_set_ret(t, 0);
		return;
	}
	phandle = vm_arg(t, 0);
	vm_arg_cstr(t, vm_arg(t, 1), id, sizeof id);
	if (!verb_create_id_ok(id)) {
		verb_seterr(vc, VERB_ERR_INVAL);
		vm_set_ret(t, 0);
		return;
	}
	if (vc->eff_owner) {
		if (g_create_max && vc->created >= g_create_max) {
			verb_seterr(vc, VERB_ERR_NOSPACE);      /* this task created enough */
			vm_set_ret(t, 0);
			return;
		}
		if (g_owned_max && obj_owner_count(vc->eff_owner) >= g_owned_max) {
			verb_seterr(vc, VERB_ERR_NOSPACE);      /* this owner owns enough */
			vm_set_ret(t, 0);
			return;
		}
	}
	if (phandle != VERB_HANDLE_NONE) {
		OBJ *parent = verb_handle_get(&vc->handles, phandle);

		pkey = parent ? obj_key(parent) : NULL;
		if (!pkey) {
			verb_seterr(vc, VERB_ERR_INVAL);
			vm_set_ret(t, 0);
			return;
		}
	}
	o = obj_create(id);                     /* NULL if the id already exists */
	if (!o) {
		verb_seterr(vc, VERB_ERR_EXISTS);
		vm_set_ret(t, 0);
		return;
	}
	if (pkey)
		obj_prop_set_internal(o, "%parent", pkey);
	if (vc->eff_owner) {
		/* Stamp ownership and register it in the owner index (also persists
		 * the record, including %parent). */
		if (obj_set_owner(id, vc->eff_owner) != OBJ_OK) {
			obj_destroy(id);
			verb_seterr(vc, VERB_ERR_INVAL);
			vm_set_ret(t, 0);
			return;
		}
	} else {
		obj_mark_dirty(o);
		obj_save(id);
	}
	h = handle_or_release(vc, o);
	if (h == VERB_HANDLE_NONE) {
		/* The table was full, so the created object got no handle. Destroy
		 * it (handle_or_release already dropped the only pin, and it set
		 * errno NOSPACE); obj_destroy also clears the owner-index entry just
		 * added, so a failed create leaves nothing persisted. */
		obj_destroy(id);
	} else if (vc->eff_owner) {
		vc->created++;                  /* count only a create that survived */
	}
	vm_set_ret(t, h);
}

/* sys_recycle(obj): destroy an object the task's authority owns (or wizard).
 * Returns 0, or -1 on a bad handle, a denied owner, the self handle, a
 * non-empty container, or a destroy the cache refuses (another pin). The handle
 * is closed on success. A member it holds is first moved to limbo so the
 * container index does not keep a stale entry. */
static void
hc_recycle(struct vm_task *t, void *ctx)
{
	struct verb_ctx *vc = vm_task_userdata(t);
	char keybuf[OBJ_PATH_MAX];
	const char *key;
	char *loc;
	OBJ *o;
	uint32_t handle;
	(void)ctx;

	handle = vm_arg(t, 0);
	o = vc ? verb_handle_get(&vc->handles, handle) : NULL;
	if (!o || handle == VERB_HANDLE_SELF) {
		verb_seterr(vc, VERB_ERR_INVAL);
		vm_set_ret(t, (uint32_t)-1);
		return;
	}
	if (!verb_may_modify(vc, o)) {
		verb_seterr(vc, VERB_ERR_DENIED);
		vm_set_ret(t, (uint32_t)-1);
		return;
	}
	key = obj_key(o);
	if (!key || obj_contents_count(key) > 0) {
		verb_seterr(vc, VERB_ERR_NOTEMPTY);
		vm_set_ret(t, (uint32_t)-1);
		return;
	}
	snprintf(keybuf, sizeof keybuf, "%s", key);
	loc = obj_location(keybuf);             /* remember home to restore on failure */
	if (loc)
		obj_move(keybuf, NULL);         /* clear its containment index entry */
	verb_handle_close(&vc->handles, handle);        /* drop our pin to destroy */
	if (obj_destroy(keybuf) != OBJ_OK) {
		/* The destroy was refused -- another handle still pins the object.
		 * Undo the limbo move so a failed recycle leaves no side effect
		 * rather than stranding the object with its index entry cleared. */
		if (loc)
			obj_move(keybuf, loc);
		free(loc);
		verb_seterr(vc, VERB_ERR_INVAL);
		vm_set_ret(t, (uint32_t)-1);
		return;
	}
	free(loc);
	vm_set_ret(t, 0);
}

/* sys_errno(): the code of the task's most recent failing call (VM_ERR_*), or
 * VM_ERR_NONE. Meaningful only right after a call that signaled failure; a
 * successful call does not clear it. */
static void
hc_errno(struct vm_task *t, void *ctx)
{
	struct verb_ctx *vc = vm_task_userdata(t);
	(void)ctx;

	vm_set_ret(t, (uint32_t)(vc ? vc->last_error : VERB_ERR_NONE));
}

/* sys_contents_count(container): the number of members directly contained by
 * the handle object, so a guest can bound a sys_next loop. A bad handle is 0. */
static void
hc_contents_count(struct vm_task *t, void *ctx)
{
	struct verb_ctx *vc = vm_task_userdata(t);
	OBJ *container;
	const char *cid;
	(void)ctx;

	container = vc ? verb_handle_get(&vc->handles, vm_arg(t, 0)) : NULL;
	cid = container ? obj_key(container) : NULL;
	if (!cid) {
		verb_seterr(vc, VERB_ERR_INVAL);
		vm_set_ret(t, 0);
		return;
	}
	vm_set_ret(t, (uint32_t)obj_contents_count(cid));
}

/* sys_broadcast(msg_ptr): send a line to everyone in the self object's room. */
static void
hc_broadcast(struct vm_task *t, void *ctx)
{
	struct verb_ctx *vc = vm_task_userdata(t);
	char line[VD_LINE_MAX];
	(void)ctx;

	vm_arg_cstr(t, vm_arg(t, 0), line, sizeof line);
	if (g_bcast && vc && vc->room_id)
		g_bcast(vc->room_id, line);
	vm_set_ret(t, 0);
}

/* Program output goes to the room a line at a time. ctx is the room id. */
void
verb_out_to_room(void *ctx, const char *buf, size_t len)
{
	const char *room_id = ctx;
	char line[VD_LINE_MAX];

	if (!g_bcast || !room_id)
		return;
	if (len >= sizeof line)
		len = sizeof line - 1;
	memcpy(line, buf, len);
	while (len > 0 && (line[len - 1] == '\n' || line[len - 1] == '\r'))
		len--;                          /* room broadcast wants a bare line */
	line[len] = 0;
	g_bcast(room_id, line);
}

/****************************************************************
 * Lifecycle and dispatch
 ****************************************************************/

int
verb_dispatch_init(const char *image_dir, verb_broadcast_fn bcast)
{
	if (g_env)
		return 0;                       /* already up */
	g_env = vm_env_new();
	if (!g_env)
		return -1;
	if (vm_env_register(g_env, VM_CALL_GETPROP, hc_getprop, NULL) != 0 ||
	    vm_env_register(g_env, VM_CALL_SETPROP, hc_setprop, NULL) != 0 ||
	    vm_env_register(g_env, VM_CALL_CLOSE, hc_close, NULL) != 0 ||
	    vm_env_register(g_env, VM_CALL_GETOBJ, hc_getobj, NULL) != 0 ||
	    vm_env_register(g_env, VM_CALL_OBJFIND, hc_objfind, NULL) != 0 ||
	    vm_env_register(g_env, VM_CALL_NEXT, hc_next, NULL) != 0 ||
	    vm_env_register(g_env, VM_CALL_MOVE, hc_move, NULL) != 0 ||
	    vm_env_register(g_env, VM_CALL_SETPRIV, hc_setpriv, NULL) != 0 ||
	    vm_env_register(g_env, VM_CALL_CREATE, hc_create, NULL) != 0 ||
	    vm_env_register(g_env, VM_CALL_RECYCLE, hc_recycle, NULL) != 0 ||
	    vm_env_register(g_env, VM_CALL_ERRNO, hc_errno, NULL) != 0 ||
	    vm_env_register(g_env, VM_CALL_CONTENTS_COUNT, hc_contents_count,
	                    NULL) != 0 ||
	    vm_env_register(g_env, VM_CALL_BROADCAST, hc_broadcast, NULL) != 0) {
		vm_env_free(g_env);
		g_env = NULL;
		return -1;
	}
	g_bcast = bcast;
	snprintf(g_image_dir, sizeof g_image_dir, "%s",
	         image_dir ? image_dir : "data/vm");

	/* The resident-agent manager shares this environment and image directory.
	 * It registers the event-routing host calls (sys_listen and friends) into
	 * g_env, so both one-shot verbs and agents draw on one flat table. */
	if (verb_agent_init(g_env) != 0) {
		vm_env_free(g_env);
		g_env = NULL;
		g_bcast = NULL;
		return -1;
	}
	return 0;
}

void
verb_dispatch_set_vfs(struct vfs *v)
{
	g_vfs = v;
}

struct vfs *
verb_dispatch_vfs(void)
{
	return g_vfs;
}

void
verb_dispatch_set_wizard_check(int (*fn)(const char *owner_id))
{
	g_may_wizard = fn;
}

void
verb_dispatch_set_quota(int per_task, int per_owner)
{
	g_create_max = per_task < 0 ? 0 : per_task;
	g_owned_max = per_owner < 0 ? 0 : per_owner;
}

int
verb_dispatch_may_wizard(const char *owner_id)
{
	return authority_may_wizard(owner_id);
}

void
verb_dispatch_shutdown(void)
{
	int i;

	for (i = 0; i < VD_MAX_FG; i++)  /* free foreground tasks before their env */
		if (g_fg[i].used)
			fg_reap(&g_fg[i]);
	verb_agent_shutdown();          /* free agent tasks before their env */
	vm_env_free(g_env);
	g_env = NULL;
	g_bcast = NULL;
	g_may_wizard = NULL;
	g_create_max = 0;
	g_owned_max = 0;
	g_vfs = NULL;
}

/* Set up a loaded task's context and output, hand it its arguments, and run it
 * to completion under the instruction cap. Returns the exit status, or -1. */
static int
run_task(struct vm_task *t, OBJ *self, const char *room_id,
         const char *const *argv, int argc)
{
	struct verb_ctx vc = { .self = self, .self_key = NULL, .room_id = room_id };
	int slices, rc;

	verb_handle_set_self(&vc.handles, self);
	vm_task_set_userdata(t, &vc);
	vm_task_set_output(t, verb_out_to_room, (void *)room_id);
	if (vm_task_set_args(t, argv, argc) != 0) {
		verb_handle_clear(&vc.handles);
		return -1;
	}
	for (slices = 0; slices < VD_MAX_SLICES; slices++)
		if (vm_task_run(t, VD_QUANTUM) != VM_READY)
			break;
	rc = vm_task_state(t) == VM_EXITED ? vm_task_exit_status(t) : -1;
	verb_handle_clear(&vc.handles);         /* release handles the run opened */
	return rc;
}

int
verb_dispatch_run_image(const uint8_t *elf, long len, OBJ *self,
                        const char *room_id, const char *const *argv, int argc)
{
	struct vm_task *t;
	int rc;

	if (!g_env)
		return -1;
	t = vm_task_new(0);
	if (!t)
		return -1;
	vm_task_set_env(t, g_env);
	if (vm_task_load_mem(t, elf, len, "<verb>") != 0) {
		vm_task_free(t);
		return -1;
	}
	rc = run_task(t, self, room_id, argv, argc);
	vm_task_free(t);
	return rc;
}

/* A program image path is relative to the image directory and may not escape
 * it: no absolute paths, no parent traversal. */
static int
path_is_safe(const char *rel)
{
	return rel && *rel && rel[0] != '/' && !strstr(rel, "..");
}

int
verb_program_resolve(const char *prog_id, char *path, size_t pathsz,
                     uint32_t *ram)
{
	char key[VD_NAME_MAX];
	char image[VD_DIR_MAX];
	OBJ *prog;
	const char *v;

	if (!prog_id)
		return -1;
	snprintf(key, sizeof key, "programs/%s", prog_id);
	prog = obj_get(key);
	if (!prog)
		return -1;
	v = obj_prop_get(prog, "image.path");
	if (!v || !path_is_safe(v)) {
		obj_release(prog);
		return -1;
	}
	snprintf(image, sizeof image, "%s", v);
	v = obj_prop_get(prog, "ram.size");
	if (ram)
		*ram = v ? (uint32_t)strtoul(v, NULL, 10) : 0;
	obj_release(prog);

	snprintf(path, pathsz, "%s/%s", g_image_dir, image);
	return 0;
}

int
verb_dispatch_oneshot(const char *prog_id, OBJ *self, const char *room_id,
                      const char *const *argv, int argc)
{
	char full[VD_PATH_MAX];
	uint32_t ram = 0;
	struct vm_task *t;
	int rc;

	if (!g_env || verb_program_resolve(prog_id, full, sizeof full, &ram) != 0)
		return -1;

	t = vm_task_new(ram);
	if (!t)
		return -1;
	vm_task_set_env(t, g_env);
	if (vm_task_load_file(t, full) != 0) {
		vm_task_free(t);
		return -1;
	}
	rc = run_task(t, self, room_id, argv, argc);
	vm_task_free(t);
	return rc;
}

/* A task's open resources are freed by vm_task_free (sched_destroy tears down
 * the guest's fs mounts and its p9 servers). Kept as a named teardown hook so
 * the call sites read clearly and a future per-task cleanup has a home. */
void
verb_program_task_end(uint32_t task_id)
{
	(void)task_id;
}

/* Open a task for program "programs/<prog_id>": size its RAM, grant it the
 * in-world 9P mount, load its image, and bind `env`. A program may carry
 * image.vfs (an absolute VFS path, loaded from the bound VFS) or image.path (a
 * host image relative to the image directory); the VFS image wins when a VFS is
 * bound. Fills *ram_out (may be NULL). Returns the task (free with
 * vm_task_free), or NULL. */
struct vm_task *
verb_program_open(const char *prog_id, struct vm_env *env, uint32_t *ram_out)
{
	char key[VD_NAME_MAX];
	char vpath[VFS_PATH_MAX];
	char hpath[VD_DIR_MAX];
	OBJ *prog;
	const char *v;
	uint32_t ram = 0;
	struct vm_task *t;
	int from_vfs = 0;

	if (!prog_id)
		return NULL;
	snprintf(key, sizeof key, "programs/%s", prog_id);
	prog = obj_get(key);
	if (!prog)
		return NULL;
	v = obj_prop_get(prog, "ram.size");
	ram = v ? (uint32_t)strtoul(v, NULL, 10) : 0;

	/* A VFS image wins when one is bound; else fall back to the host image. */
	vpath[0] = hpath[0] = '\0';
	v = g_vfs ? obj_prop_get(prog, "image.vfs") : NULL;
	if (v && v[0] == '/') {
		snprintf(vpath, sizeof vpath, "%s", v);
		from_vfs = 1;
	} else {
		v = obj_prop_get(prog, "image.path");
		if (!v || !path_is_safe(v)) {
			obj_release(prog);
			return NULL;
		}
		snprintf(hpath, sizeof hpath, "%s", v);
	}
	obj_release(prog);

	t = vm_task_new(ram);
	if (!t)
		return NULL;
	vm_task_set_env(t, env);
	/* Give the program the in-world tree as a 9P mount. A band command verb
	 * links no fs table, so the grant is a harmless no-op there; a libc program
	 * reaches files through it. */
	if (g_vfs)
		vm_task_add_p9_mount(t, VD_WORLD_MOUNT, g_image_dir);
	if (from_vfs) {
		void *elf = NULL;
		size_t elen = 0;
		int ok;

		if (vfs_read(g_vfs, vpath, &elf, &elen) != VFS_OK) {
			vm_task_free(t);
			return NULL;
		}
		ok = vm_task_load_mem(t, elf, (long)elen, vpath) == 0;
		free(elf);
		if (!ok) {
			vm_task_free(t);
			return NULL;
		}
	} else {
		char full[VD_PATH_MAX];

		snprintf(full, sizeof full, "%s/%s", g_image_dir, hpath);
		if (vm_task_load_file(t, full) != 0) {
			vm_task_free(t);
			return NULL;
		}
	}
	if (ram_out)
		*ram_out = ram;
	return t;
}

/* Create or update "programs/<prog_id>" so it launches the VFS image at
 * vfs_path, with ram bytes of guest RAM (0 for the default). Persists
 * immediately. Returns 0, or -1 on a bad argument or a store failure. This is
 * the P3 bind step: a compiled image in the VFS becomes a launchable program. */
int
verb_program_bind_vfs(const char *prog_id, const char *vfs_path, uint32_t ram)
{
	char key[VD_NAME_MAX];
	OBJ *prog;
	int rc = 0;

	if (!prog_id || !prog_id[0] || strchr(prog_id, '/') ||
	    !vfs_path || vfs_path[0] != '/')
		return -1;
	snprintf(key, sizeof key, "programs/%s", prog_id);
	prog = obj_get(key);
	if (!prog)
		prog = obj_create(key);
	if (!prog)
		return -1;
	if (obj_prop_set(prog, "image.vfs", vfs_path) != OBJ_OK)
		rc = -1;
	if (obj_prop_set(prog, "image.path", "") != OBJ_OK)
		rc = -1;
	if (ram && obj_prop_set_int(prog, "ram.size", (int)ram) != OBJ_OK)
		rc = -1;
	obj_mark_dirty(prog);
	obj_release(prog);
	if (rc == 0 && obj_save(key) != OBJ_OK)
		rc = -1;
	return rc;
}

/* Register an existing ELF image as "programs/<prog_id>". An image beginning
 * with '/' is a VFS path (needs a bound VFS and an existing file); otherwise a
 * host image relative to the image directory (a safe relative path naming an
 * existing file). The chosen kind is set and the other cleared, so a re-register
 * switches cleanly. Returns 0, or -1 with errbuf (may be NULL) filled. */
int
verb_program_register(const char *prog_id, const char *image, uint32_t ram,
                      char *errbuf, size_t errsz)
{
	char key[VD_NAME_MAX];
	OBJ *prog;
	int from_vfs, rc = 0;

	if (!prog_id || !prog_id[0] || strchr(prog_id, '/')) {
		if (errbuf && errsz)
			snprintf(errbuf, errsz, "a program id must be a single name");
		return -1;
	}
	if (!image || !image[0]) {
		if (errbuf && errsz)
			snprintf(errbuf, errsz, "no image given");
		return -1;
	}
	from_vfs = image[0] == '/';
	if (from_vfs) {
		struct vfs_stat st;

		if (!g_vfs) {
			if (errbuf && errsz)
				snprintf(errbuf, errsz, "no in-world VFS for a VFS image");
			return -1;
		}
		if (vfs_stat(g_vfs, image, &st) != VFS_OK) {
			if (errbuf && errsz)
				snprintf(errbuf, errsz, "no such VFS file: %s", image);
			return -1;
		}
	} else {
		char full[VD_PATH_MAX];

		if (!path_is_safe(image)) {
			if (errbuf && errsz)
				snprintf(errbuf, errsz, "a host image must be a relative path "
				         "that does not escape the image directory");
			return -1;
		}
		snprintf(full, sizeof full, "%s/%s", g_image_dir, image);
		if (access(full, R_OK) != 0) {
			if (errbuf && errsz)
				snprintf(errbuf, errsz, "no such host image: %s", full);
			return -1;
		}
	}

	snprintf(key, sizeof key, "programs/%s", prog_id);
	prog = obj_get(key);
	if (!prog)
		prog = obj_create(key);
	if (!prog) {
		if (errbuf && errsz)
			snprintf(errbuf, errsz, "cannot create programs/%s", prog_id);
		return -1;
	}
	if (from_vfs) {
		if (obj_prop_set(prog, "image.vfs", image) != OBJ_OK)
			rc = -1;
		if (obj_prop_set(prog, "image.path", "") != OBJ_OK)
			rc = -1;
	} else {
		if (obj_prop_set(prog, "image.path", image) != OBJ_OK)
			rc = -1;
		if (obj_prop_set(prog, "image.vfs", "") != OBJ_OK)
			rc = -1;
	}
	if (obj_prop_set_int(prog, "ram.size", (int)ram) != OBJ_OK)
		rc = -1;
	obj_mark_dirty(prog);
	obj_release(prog);
	if (rc == 0 && obj_save(key) != OBJ_OK)
		rc = -1;
	if (rc != 0 && errbuf && errsz && !errbuf[0])
		snprintf(errbuf, errsz, "could not persist programs/%s", prog_id);
	return rc;
}

int
verb_program_unregister(const char *prog_id)
{
	char key[VD_NAME_MAX];
	OBJ *prog;

	if (!prog_id || !prog_id[0] || strchr(prog_id, '/'))
		return -1;
	snprintf(key, sizeof key, "programs/%s", prog_id);
	prog = obj_get(key);
	if (!prog)
		return 1;                       /* no such program */
	obj_release(prog);
	return obj_delete(key) == OBJ_OK ? 0 : -1;
}

/* obj_foreach_key wrapper: look each program key up, read its bound image, and
 * forward to the caller's verb_program_list_fn. */
struct vd_list_ctx {
	verb_program_list_fn cb;
	void *ctx;
};

static void
vd_list_one(const char *key, void *vctx)
{
	struct vd_list_ctx *s = vctx;
	OBJ *prog;
	const char *vfs, *host, *prog_id;

	prog = obj_get(key);
	if (!prog)
		return;
	vfs = obj_prop_get(prog, "image.vfs");
	host = obj_prop_get(prog, "image.path");
	prog_id = strchr(key, '/');
	prog_id = prog_id ? prog_id + 1 : key;
	if (vfs && vfs[0] == '/')
		s->cb(prog_id, vfs, 1, s->ctx);
	else
		s->cb(prog_id, host && host[0] ? host : "", 0, s->ctx);
	obj_release(prog);
}

int
verb_program_list(verb_program_list_fn cb, void *ctx)
{
	struct vd_list_ctx s;

	if (!cb)
		return -1;
	s.cb = cb;
	s.ctx = ctx;
	return obj_foreach_key("programs/", vd_list_one, &s);
}

/****************************************************************
 * Foreground interactive sessions
 ****************************************************************/

static struct verb_fg *
fg_by_id(uint32_t id)
{
	int i;

	for (i = 0; i < VD_MAX_FG; i++)
		if (g_fg[i].used && g_fg[i].id == id)
			return &g_fg[i];
	return NULL;
}

/* Free the task and its context and clear the slot. Does not call the exit
 * hook; the caller decides whether to. */
static void
fg_reap(struct verb_fg *s)
{
	verb_handle_clear(&s->ctx.handles);     /* release handles the run opened */
	verb_program_task_end(vm_task_id(s->task));
	vm_task_free(s->task);
	if (s->self)
		obj_release(s->self);           /* self is borrowed by the handle table */
	memset(s, 0, sizeof *s);
}

/* vm_output_fn: forward a line of the task's stdout to the host sink. */
static void
fg_out(void *ctx, const char *buf, size_t len)
{
	struct verb_fg *s = ctx;

	if (s->out)
		s->out(s->hook_ctx, buf, len);
}

uint32_t
verb_fg_launch(const char *prog_id, const char *actor_id,
               const char *const *argv, int argc,
               verb_fg_output_fn out, verb_fg_exit_fn on_exit, void *hook_ctx)
{
	struct verb_fg *s = NULL;
	struct vm_task *t;
	OBJ *self;
	const char *owner;
	char *loc;
	int i;

	if (!g_env || !prog_id || !actor_id || !out)
		return 0;
	for (i = 0; i < VD_MAX_FG; i++)
		if (!g_fg[i].used) {
			s = &g_fg[i];
			break;
		}
	if (!s)
		return 0;                       /* table full */
	self = obj_get(actor_id);
	if (!self)
		return 0;
	t = verb_program_open(prog_id, g_env, NULL);
	if (!t) {
		obj_release(self);
		return 0;
	}

	memset(s, 0, sizeof *s);
	snprintf(s->actor, sizeof s->actor, "%s", actor_id);
	loc = obj_location(actor_id);           /* the player's room, NULL in limbo */
	if (loc) {
		snprintf(s->room, sizeof s->room, "%s", loc);
		free(loc);
	}
	owner = obj_prop_get(self, "%owner");
	if (owner)
		snprintf(s->real_owner, sizeof s->real_owner, "%s", owner);

	s->ctx.self = self;
	s->ctx.actor_id = s->actor;
	s->ctx.room_id = s->room[0] ? s->room : NULL;
	s->ctx.real_owner = s->real_owner[0] ? s->real_owner : NULL;
	authority_set_owner(&s->ctx, s->actor);         /* runs as the player */
	verb_handle_set_self(&s->ctx.handles, self);

	s->task = t;
	s->self = self;
	s->out = out;
	s->on_exit = on_exit;
	s->hook_ctx = hook_ctx;
	s->id = vm_task_id(t);

	vm_task_set_userdata(t, &s->ctx);
	vm_task_set_output(t, fg_out, s);
	if (vm_task_set_args(t, argv, argc) != 0) {
		fg_reap(s);
		return 0;
	}
	s->used = 1;
	return s->id;
}

int
verb_fg_feed(uint32_t id, const char *data, uint32_t len)
{
	struct verb_fg *s = fg_by_id(id);

	if (!s)
		return -1;
	return vm_task_feed_stdin(s->task, data, len);
}

void
verb_fg_request_quit(uint32_t id)
{
	struct verb_fg *s = fg_by_id(id);

	if (!s)
		return;
	vm_task_close_stdin(s->task);           /* a parked read sees EOF */
	s->quitting = 1;                        /* killed next tick if still live */
}

void
verb_fg_close(uint32_t id)
{
	struct verb_fg *s = fg_by_id(id);

	if (s)
		fg_reap(s);                     /* silent: no exit hook */
}

int
verb_fg_tick(int quantum)
{
	int i, live = 0;

	if (quantum < 1)
		quantum = 1;
	for (i = 0; i < VD_MAX_FG; i++) {
		struct verb_fg *s = &g_fg[i];
		enum vm_state st;

		if (!s->used)
			continue;
		st = vm_task_run(s->task, quantum);
		if (st == VM_EXITED || st == VM_FAULTED) {
			int status = st == VM_EXITED ? vm_task_exit_status(s->task) : -1;
			int faulted = st == VM_FAULTED;
			verb_fg_exit_fn cb = s->on_exit;
			void *ctx = s->hook_ctx;

			fg_reap(s);             /* free before the hook runs */
			if (cb)
				cb(ctx, status, faulted);
		} else if (s->quitting) {
			/* It had its grace tick after stdin closed and did not exit. */
			verb_fg_exit_fn cb = s->on_exit;
			void *ctx = s->hook_ctx;

			fg_reap(s);
			if (cb)
				cb(ctx, -1, 1);
		} else {
			live++;
		}
	}
	return live;
}

int
verb_fg_count(void)
{
	int i, n = 0;

	for (i = 0; i < VD_MAX_FG; i++)
		if (g_fg[i].used)
			n++;
	return n;
}

/* Bind one matched segment into a slot. Object and player tokens resolve a name
 * in the actor's scope and pre-seed an owned handle; other tokens copy the
 * matched text into segbuf as a NUL-terminated string. Returns 0, or a
 * VERB_CMD_* code on failure. */
static int
bind_segment(struct verb_ctx *vc, const char *actor_id,
             enum verb_token_type type, const struct verb_match_seg *seg,
             struct vm_typed_arg *slot, char *segbuf, size_t segcap,
             size_t *segoff)
{
	if (type == VTOK_OBJ || type == VTOK_PLAYER) {
		char name[OBJ_PATH_MAX], id[OBJ_PATH_MAX];
		int players_only = (type == VTOK_PLAYER);
		OBJ *o;
		unsigned h;

		if (seg->len >= (int)sizeof name)
			return VERB_CMD_BADARG;
		memcpy(name, seg->str, (size_t)seg->len);
		name[seg->len] = '\0';
		if (resolve_name(actor_id, name, players_only, id, sizeof id)
		    != RESOLVE_OK)
			return VERB_CMD_BADARG;
		o = obj_get(id);
		if (!o)
			return VERB_CMD_BADARG;
		h = verb_handle_add(&vc->handles, o);
		if (h == VERB_HANDLE_NONE) {
			obj_release(o);
			return VERB_CMD_ERROR;
		}
		slot->type = VERB_ARG_OBJ;
		slot->ival = h;
		slot->str = NULL;
		return 0;
	}

	if (*segoff + (size_t)seg->len + 1 > segcap)
		return VERB_CMD_ERROR;
	memcpy(segbuf + *segoff, seg->str, (size_t)seg->len);
	segbuf[*segoff + seg->len] = '\0';
	slot->type = VERB_ARG_STR;
	slot->ival = 0;
	slot->str = segbuf + *segoff;
	*segoff += (size_t)seg->len + 1;
	return 0;
}

int
verb_dispatch_command(const char *actor_id, const char *word, const char *rest)
{
	struct verb_def def;
	struct verb_spec spec;
	struct verb_match match;
	struct verb_ctx vc;
	struct vm_typed_arg slots[VERB_SPEC_MAX_TOKENS];
	char segbuf[VD_LINE_MAX];
	char full[VD_PATH_MAX];
	char real_owner[OBJ_PATH_MAX];
	const char *holder_owner;
	size_t segoff = 0;
	uint32_t ram = 0;
	OBJ *self = NULL;
	char *room = NULL;
	struct vm_task *t = NULL;
	int rc, i, slices;

	if (!g_env || !actor_id || !word)
		return VERB_CMD_ERROR;
	if (verb_resolve(actor_id, word, &def) != 1)
		return VERB_CMD_NOVERB;
	if (verb_spec_parse(def.spec, &spec) != 0)
		return VERB_CMD_ERROR;
	if (verb_spec_match(&spec, rest ? rest : "", &match) != 0)
		return VERB_CMD_NOMATCH;
	if (verb_program_resolve(def.prog, full, sizeof full, &ram) != 0)
		return VERB_CMD_ERROR;

	self = obj_get(def.holder);
	if (!self)
		return VERB_CMD_ERROR;
	room = obj_location(actor_id);          /* output room, NULL in limbo */

	memset(&vc, 0, sizeof vc);
	vc.self = self;
	vc.actor_id = actor_id;
	vc.room_id = room;
	/* The attached object's owner is the real identity a program may assume;
	 * copy it so a later write to self cannot invalidate the borrowed value. */
	holder_owner = obj_prop_get(self, "%owner");
	if (holder_owner) {
		snprintf(real_owner, sizeof real_owner, "%s", holder_owner);
		vc.real_owner = real_owner;
	}
	authority_set_owner(&vc, actor_id);     /* effective owner = the initiator */
	verb_handle_set_self(&vc.handles, self);

	for (i = 0; i < match.nsegs; i++) {
		rc = bind_segment(&vc, actor_id, spec.tokens[i].type,
		                  &match.segs[i], &slots[i], segbuf,
		                  sizeof segbuf, &segoff);
		if (rc != 0)
			goto done;
	}

	t = vm_task_new(ram);
	if (!t) {
		rc = VERB_CMD_ERROR;
		goto done;
	}
	vm_task_set_env(t, g_env);
	if (vm_task_load_file(t, full) != 0) {
		rc = VERB_CMD_ERROR;
		goto done;
	}
	vm_task_set_userdata(t, &vc);
	vm_task_set_output(t, verb_out_to_room, (void *)room);
	if (vm_task_set_typed_args(t, slots, match.nsegs) != 0) {
		rc = VERB_CMD_ERROR;
		goto done;
	}
	for (slices = 0; slices < VD_MAX_SLICES; slices++)
		if (vm_task_run(t, VD_QUANTUM) != VM_READY)
			break;
	/* Verbs return nothing to the caller: a clean run is 0 regardless of the
	 * program's own exit status, so the status can never alias a VERB_CMD_
	 * code. A fault (never reached VM_EXITED) is an error. */
	rc = vm_task_state(t) == VM_EXITED ? 0 : VERB_CMD_ERROR;

done:
	verb_handle_clear(&vc.handles);         /* release pre-seeded handles */
	if (t)
		vm_task_free(t);
	obj_release(self);
	free(room);
	return rc;
}
