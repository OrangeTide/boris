/* verb_agent.h : resident agent tasks, their mailboxes, and event routing */

#ifndef VERB_AGENT_H_
#define VERB_AGENT_H_

#include <stdint.h>

struct vm_env;
struct obj;

/* Bring up the agent manager. It shares the caller's host-call environment (the
 * one verb_dispatch owns) and registers the event-routing host calls
 * (sys_listen, sys_notify, sys_post, sys_taskid) into env. Program images are
 * resolved through verb_program_resolve. Returns 0, or -1. Idempotent. */
int verb_agent_init(struct vm_env *env);

/* Free every resident task and clear the manager. Call before freeing the
 * shared environment, since the tasks reference it. */
void verb_agent_shutdown(void);

/* Launch a resident task from program object "programs/<prog_id>", attached to
 * that program object as its self, broadcasting to room_id. The task stays live
 * across ticks until it exits or faults. Returns its task id (nonzero), or 0 on
 * failure. */
uint32_t verb_agent_launch(const char *prog_id, const char *room_id);

/* Launch a resident task from an in-memory ELF, for tests and callers that hold
 * the image bytes. self is the object the task acts on and its events route
 * under self_key; the caller keeps ownership of self (it is not released on
 * reap). Returns the task id (nonzero), or 0 on failure. */
uint32_t verb_agent_launch_image(const uint8_t *elf, long len, struct obj *self,
                                 const char *self_key, const char *room_id);

/* Step every live agent by up to quantum instructions, then reap the ones that
 * finished. A task blocked on its mailbox costs nothing. Returns the number of
 * agents still live. Wire this to a timer tick. */
int verb_agent_tick(int quantum);

/* Deliver an event to the agent listening on listen_key (the self key it passed
 * to sys_listen). Used by the game to post enter events and the like. Returns 0
 * if it was queued, -1 if no one listens or the mailbox is full. */
int verb_agent_deliver(const char *listen_key, uint32_t kind, uint32_t sender,
                       const char *str, uint32_t len);

/* Deliver an event straight to a task by id, whether or not it listens. This is
 * how a sequential task blocked on sys_suspend is resumed. Returns 0, -1 on a
 * missing task or a full mailbox. */
int verb_agent_post(uint32_t taskid, uint32_t kind, uint32_t sender,
                    const char *str, uint32_t len);

/* Number of live resident agents. */
int verb_agent_count(void);

/****************************************************************
 * Resident supervision (sysvinit-style respawn)
 ****************************************************************/

/* Set the list of resident program ids to keep running, as a comma-separated
 * string (spaces around ids are trimmed; an empty string clears the list). The
 * supervisor launches these and relaunches any that exit or fault. */
void verb_agent_set_resident(const char *csv);

/* Bring the live set in line with the resident list: launch any resident that
 * is not currently running, throttled so a program that keeps dying is retried
 * at a bounded rate rather than every tick. Call once per timer tick after
 * verb_agent_tick. Returns the number of launch attempts made this call. */
int verb_agent_supervise(void);

#endif /* VERB_AGENT_H_ */
