/* vmsys.h : host-call interface for VM guest programs.
 *
 * Each function is a stub in the guest runtime (stubs.S) that issues an ecall
 * to the named host service. The host binds these names to its implementation
 * at load. See doc/mud-vm-design.md "Host-Call Set". */

#ifndef VMSYS_H
#define VMSYS_H

/* Largest event payload the host keeps per mailbox event. */
#define VM_MSG_MAX 256

/* sys_suspend modes (the `kind` argument). */
#define VM_SUSPEND_YIELD 0      /* run again on the next tick */
#define VM_SUSPEND_EVENT 1      /* park until a mailbox event arrives */
#define VM_SUSPEND_SLEEP 2      /* park until `arg` ms pass, then a timer event */

/* Event kinds delivered to a program's mailbox. VM_EV_NONE is what sys_getmsg
 * returns when the mailbox is empty. */
#define VM_EV_NONE  0
#define VM_EV_ENTER 1           /* something entered the program's object */
#define VM_EV_TIMER 2           /* the dwell timer fired */
#define VM_EV_USER  3           /* a user event carrying a string payload */
#define VM_EV_WAKE  4           /* a bare wake, no payload */

/* One mailbox event, as sys_getmsg marshals it into guest memory. */
typedef struct {
	unsigned kind;
	unsigned sender;                /* task id or object handle */
	unsigned len;                   /* payload length in str */
	char     str[VM_MSG_MAX];       /* NUL-terminated payload */
} vm_event_t;

/* Runtime and I/O (always available). */
void     sys_exit(int status);
int      sys_write(int fd, const void *buf, int len);
unsigned sys_random(unsigned bound);
unsigned sys_now(void);
void     sys_suspend(unsigned kind, unsigned arg);

/* Mailbox: drain one event into `rec` (cap is its size), returning its kind or
 * VM_EV_NONE when empty. Non-blocking; pair with sys_suspend(VM_SUSPEND_EVENT)
 * to wait. Always available. */
int sys_getmsg(void *rec, int cap);

/* Reserved object handles. 0 is "no object" (a handle-returning call uses it
 * for failure); 1 is the program's own self object. Other handles are opened by
 * the object-access calls and closed with sys_close. */
#define VM_HANDLE_NONE 0u
#define VM_HANDLE_SELF 1u

/* Object access and messaging (provided by the game host; unbound programs
 * that call these fault). getprop/setprop act on an object handle; pass
 * VM_HANDLE_SELF for the program's own object. sys_close releases a handle the
 * program no longer needs. */
int  sys_getprop(unsigned obj, const char *name, char *buf, int cap);
int  sys_setprop(unsigned obj, const char *name, const char *value);
void sys_close(unsigned obj);
void sys_broadcast(const char *line);

/* Object lookup (provided by the game host). sys_getobj follows the string
 * property `name` of `obj` as an object id; sys_objfind resolves `name` in the
 * caller's scope (players_only restricts to characters); sys_next returns the
 * ordinal-th member of a container. Each returns a new handle, or VM_HANDLE_NONE
 * on failure or end of iteration. A program iterating a container with sys_next
 * should sys_close each handle it is done with so its handle table does not
 * fill. */
unsigned sys_getobj(unsigned obj, const char *name);
unsigned sys_objfind(const char *name, int players_only);
unsigned sys_next(unsigned container, unsigned ordinal);

/* Number of members directly contained by the handle object. Pairs with
 * sys_next: a guest bounds its loop by this count so a premature VM_HANDLE_NONE
 * (before the count) is a real error rather than the end of iteration. */
unsigned sys_contents_count(unsigned container);

/* Failure codes from sys_errno. A call that returns a failure value records
 * one; a successful call does not touch it. VM_ERR_NONE is the initial value. */
#define VM_ERR_NONE      0
#define VM_ERR_DENIED    1      /* not the owner and not wizard */
#define VM_ERR_NOTFOUND  2      /* no such object, name, or property */
#define VM_ERR_AMBIGUOUS 3      /* a name matched more than one object */
#define VM_ERR_EXISTS    4      /* sys_create: the id is already in use */
#define VM_ERR_INVAL     5      /* bad argument: handle, id, mode, or move */
#define VM_ERR_NOSPACE   6      /* the handle table is full */
#define VM_ERR_NOTEMPTY  7      /* sys_recycle: the container still has members */

/* The code of this task's most recent failing call (provided by the game
 * host). Read it only right after a call returns its failure value; it is not
 * cleared on success, so at any other time it is stale. For example, after
 * sys_objfind returns VM_HANDLE_NONE it distinguishes VM_ERR_NOTFOUND from
 * VM_ERR_AMBIGUOUS. */
int sys_errno(void);

/* Relocate `member` into `container` (provided by the game host). Pass
 * VM_HANDLE_NONE as the container to send it to limbo. Returns 0 on success, -1
 * if a handle is invalid or the move would form a containment cycle. */
int sys_move(unsigned member, unsigned container);

/* sys_setpriv modes. Authority has two orthogonal axes: the effective owner
 * identity (checked against an object's owner) and the wizard flag. A program
 * raises what it needs for the smallest region, then drops. */
#define VM_PRIV_WIZ_ON    1u    /* enable wizard (denied if not permitted) */
#define VM_PRIV_WIZ_OFF   2u    /* drop wizard */
#define VM_PRIV_AS_OWNER  3u    /* act as the attached object's owner */
#define VM_PRIV_AS_CALLER 4u    /* act as the command initiator (the default) */

/* Adjust the running program's authority (provided by the game host), seteuid
 * style. Returns 0, or -1 when an elevation is not permitted or there is no
 * identity to assume. */
int sys_setpriv(unsigned mode);

/* Create a new persistent object (provided by the game host). `id` is the
 * guest-chosen key; it may not fall in a system namespace. The object is owned
 * by the caller's effective owner and parented to `parent` (VM_HANDLE_NONE for
 * none). Returns a new handle, or VM_HANDLE_NONE if the id is rejected or in
 * use, the parent handle is bad, or the handle table is full. sys_recycle
 * destroys an object the caller owns (empty containers only) and closes the
 * handle; returns 0 or -1. */
unsigned sys_create(unsigned parent, const char *id);
int      sys_recycle(unsigned obj);

/* Events and other tasks (provided by the game host). sys_listen routes the
 * program's own object events to it; sys_notify delivers a user event and
 * string to the task listening on `key`; sys_post wakes a task by id; sys_taskid
 * returns the caller's task id. */
int      sys_listen(void);
int      sys_notify(const char *key, const char *str);
int      sys_post(unsigned taskid);
unsigned sys_taskid(void);

#endif /* VMSYS_H */
