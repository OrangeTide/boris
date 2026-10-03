/* verb_handle.h : per-task object-handle table (ARC over the obj cache) */

#ifndef VERB_HANDLE_H_
#define VERB_HANDLE_H_

struct obj;

/* Handle slots per task, including the reserved none/self slots. */
#define VERB_HANDLE_MAX  32

/* Reserved handle values. 0 is "no handle", so a call that returns a handle can
 * use 0 for failure; 1 is the task's self object. Dynamic handles are 2.. */
#define VERB_HANDLE_NONE 0u
#define VERB_HANDLE_SELF 1u

struct verb_handle_slot {
	struct obj *ref;        /* NULL when the slot is free */
	int owned;              /* 1: release ref on close/clear; 0: borrowed */
};

/*
 * A fixed table mapping small integer handles to objects. The guest addresses
 * objects by these handles. Adding an object pins it (the table takes ownership
 * of the caller's obj_get reference); closing or clearing releases it. The self
 * slot is borrowed: the table never releases it, since its owner (the agent
 * manager, or the one-shot's caller) does. The struct is embedded in a task's
 * context and may start zeroed (all slots free).
 */
struct verb_handles {
	struct verb_handle_slot slot[VERB_HANDLE_MAX];
};

/* Seat self at VERB_HANDLE_SELF as a borrowed reference (self may be NULL). */
void verb_handle_set_self(struct verb_handles *h, struct obj *self);

/*
 * Add obj as a new dynamic handle and return it (>= 2), or VERB_HANDLE_NONE if
 * the table is full. On success the table owns obj's reference and releases it
 * on close or clear; on failure it takes no ownership, so the caller keeps its
 * reference to release.
 */
unsigned verb_handle_add(struct verb_handles *h, struct obj *obj);

/* Resolve a handle to its object, or NULL for none/invalid/free. */
struct obj *verb_handle_get(struct verb_handles *h, unsigned handle);

/* Release and free a dynamic handle. A no-op for none/self/invalid/free. */
void verb_handle_close(struct verb_handles *h, unsigned handle);

/* Release every owned (dynamic) handle. The borrowed self slot is left alone.
 * Call at task teardown. */
void verb_handle_clear(struct verb_handles *h);

#endif /* VERB_HANDLE_H_ */
