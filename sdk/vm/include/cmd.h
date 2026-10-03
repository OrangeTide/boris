/* cmd.h : the command-verb runtime contract.
 *
 * A command verb is a one-shot program dispatched by the host when a player
 * types a matching command word. Unlike a plain program, it is not entered with
 * a C argv. The host writes a typed argument vector built from the verb's
 * argument spec: a0 = the slot count, a1 = an array of {u32 type, u32 value}
 * slots in spec order. An object token carries an object handle; an atom, a
 * free word, a preposition, or an <any> remainder carries a guest pointer to a
 * NUL-terminated string.
 *
 * A command verb links cmd_crt.S (which stashes a0/a1 and calls main) and this
 * runtime, then defines main(). It reads its arguments with the va_arg-style
 * accessors below, each of which advances a cursor and checks the next slot's
 * type. Pulling the wrong type, or reading past the last slot, returns a
 * failure value rather than faulting; a verb written against its own spec pulls
 * in the order the spec declares. */

#ifndef VM_CMD_H
#define VM_CMD_H

#include "vmsys.h"

/* Slot type tags. Kept in step with the host (src/verb), which builds the
 * slots. CMD_ARG_NONE never appears in a slot; it is what the accessors report
 * past the end of the vector. */
#define CMD_ARG_NONE 0u
#define CMD_ARG_OBJ  1u         /* value is an object handle */
#define CMD_ARG_STR  2u         /* value is a guest pointer to a NUL string */

/* Number of argument slots the verb was given. */
unsigned cmd_arg_count(void);

/* Rewind the argument cursor to the first slot. */
void cmd_arg_reset(void);

/* The tag of the next slot without consuming it (CMD_ARG_NONE past the end). */
unsigned cmd_arg_peek(void);

/* Consume the next slot as an object handle and return it. Returns
 * VM_HANDLE_NONE if the cursor is at the end or the next slot is not an object
 * slot (the cursor does not advance on a type mismatch). */
unsigned cmd_arg_obj(void);

/* Consume the next slot as a string and return a pointer to it. Returns NULL if
 * the cursor is at the end or the next slot is not a string slot (the cursor
 * does not advance on a type mismatch). */
const char *cmd_arg_str(void);

#endif /* VM_CMD_H */
