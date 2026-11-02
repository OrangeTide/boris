/* verb_dispatch.h : one-shot dispatch of guest programs against game objects */

#ifndef VERB_DISPATCH_H_
#define VERB_DISPATCH_H_

#include <stddef.h>
#include <stdint.h>

#include "verb_handle.h"

struct obj;
struct vfs;

/* Per-task context the shared host calls read back through vm_task_userdata. A
 * one-shot task keeps this on the stack for its single run; a resident agent
 * task keeps a copy alive for its whole life. self_key names the object for
 * event routing and is NULL for a one-shot that never listens. handles is the
 * task's object-handle table; self is seated at VERB_HANDLE_SELF. actor_id, when
 * set, is the acting character's object id for scope resolution (L5b). */
struct verb_ctx {
	struct obj *self;
	const char *self_key;
	const char *room_id;
	const char *actor_id;
	/* Authority (L7). eff_owner is the effective owner id a write/move/recycle
	 * is checked against an object's %owner; it is the command initiator for a
	 * player-launched verb. A NULL eff_owner is a host-initiated (system) task
	 * and is not checked. real_owner is the attached object's %owner, the one
	 * other identity a program may switch its effective owner to (sys_setpriv),
	 * then back to the initiator (actor_id). is_wizard is the orthogonal admin
	 * flag, off until a program elevates; wiz_available is whether the current
	 * effective identity is durably permitted to, recomputed when eff_owner
	 * changes. */
	const char *eff_owner;
	const char *real_owner;
	int is_wizard;
	int wiz_available;
	/* The code of the task's most recent failing host call (sys_errno). Set on
	 * failure, never cleared on success, so it is meaningful only immediately
	 * after a call that signaled failure. Starts VM_ERR_NONE. */
	int last_error;
	/* Count of objects this task has created (sys_create), for the per-task
	 * creation quota. Only tasks with an effective owner are capped. */
	int created;
	struct verb_handles handles;
};

/* How the dispatcher delivers a program's output to a room. The host binds
 * this so the module needs no telnet or network dependency of its own. */
typedef void (*verb_broadcast_fn)(const char *room_id, const char *line);

/* A vm_output_fn that sends a task's output to a room a line at a time. ctx is
 * the room id. Shared so agent tasks route output the same way one-shots do. */
void verb_out_to_room(void *ctx, const char *buf, size_t len);

/* Build the shared host-call environment, record where program images live,
 * and bind output delivery. Returns 0, or -1 on failure. Calling it twice is
 * a no-op that keeps the first environment. */
int verb_dispatch_init(const char *image_dir, verb_broadcast_fn bcast);

/* Free the host-call environment. */
void verb_dispatch_shutdown(void);

/* Bind the in-world VFS the host-side tools (the @f* authoring commands and the
 * web file-transfer endpoints) read and write. The VFS must outlive the bind;
 * pass NULL to unbind before freeing it. verb_dispatch_vfs returns the bound
 * VFS, or NULL when none is set. */
void verb_dispatch_set_vfs(struct vfs *v);
struct vfs *verb_dispatch_vfs(void);

/* Register the durable wizard-capability query: given an effective owner id,
 * return non-zero if that identity's account is permitted to enable wizard
 * (sys_setpriv). Supplied by the session/account layer; when unset, no identity
 * may elevate. */
void verb_dispatch_set_wizard_check(int (*fn)(const char *owner_id));

/* Set the object-creation quotas, both in objects. per_task caps how many
 * objects one verb task may create (sys_create); per_owner caps how many
 * objects an effective owner may own in total. Zero (or negative) means no
 * limit. System and agent tasks (no effective owner) are never capped. */
void verb_dispatch_set_quota(int per_task, int per_owner);

/* Whether `owner_id`'s account is durably permitted to enable wizard, via the
 * registered wizard check (0 when none is registered). The agent launcher uses
 * it to seat wiz_available on an agent that runs as its object's owner. */
int verb_dispatch_may_wizard(const char *owner_id);

/* Resolve a program object (key "programs/<prog_id>") to its ELF image, run
 * it once against `self` with the given arguments, and reap it. `self` is the
 * object the program is attached to, pinned by the caller; `room_id` names the
 * room its output broadcasts to. Returns the program's exit status (>= 0), or
 * -1 if it could not be launched or it faulted. */
int verb_dispatch_oneshot(const char *prog_id, struct obj *self,
                          const char *room_id,
                          const char *const *argv, int argc);

/* Run an in-memory ELF once against `self`, for tests and callers that already
 * hold the image bytes. Same return convention as verb_dispatch_oneshot. */
int verb_dispatch_run_image(const uint8_t *elf, long len, struct obj *self,
                            const char *room_id,
                            const char *const *argv, int argc);

/* Resolve a program object (key "programs/<prog_id>") to the full path of its
 * ELF image, joined with the image directory, and its requested RAM size (0
 * for the default). Returns 0, or -1 if the object is absent or its image path
 * is unsafe. Shared by one-shot dispatch and the agent launcher. */
int verb_program_resolve(const char *prog_id, char *path, size_t pathsz,
                         uint32_t *ram);

/* verb_dispatch_command outcomes. 0 means a verb ran; the negatives are the
 * failures before (or instead of) a run. A verb's own exit status is not
 * surfaced -- verbs return nothing to the caller -- so a run is always 0 and a
 * program can never alias one of these codes. */
#define VERB_CMD_OK      (0)    /* a verb was found, bound, and ran */
#define VERB_CMD_NOVERB  (-1)   /* no verb.<word> in the actor's scope */
#define VERB_CMD_NOMATCH (-2)   /* a verb matched the word but not the args */
#define VERB_CMD_BADARG  (-3)   /* an object/player argument did not resolve */
#define VERB_CMD_ERROR   (-4)   /* load/parse/internal failure */

/* Run the command `word rest` on behalf of the actor. Resolve verb.<word> in
 * the actor's scope (verb_resolve), match `rest` against its argument spec,
 * resolve each object/player argument to a pre-seeded handle (failing the whole
 * command if one is absent or ambiguous), and run the bound program with the
 * typed argument vector. The verb's self is the object it was found on; output
 * broadcasts to the actor's location. Returns VERB_CMD_OK when a verb ran, or
 * one of the negative VERB_CMD_* codes. `rest` may be NULL or empty. */
int verb_dispatch_command(const char *actor_id, const char *word,
                          const char *rest);

#endif /* VERB_DISPATCH_H_ */
