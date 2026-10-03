/* cmd_rt.c : the command-verb argument runtime.
 *
 * cmd_crt.S calls cmd_args_init with the typed argument vector the host built
 * from the verb's spec, then calls the verb's main. The cmd_arg_* accessors
 * walk the slots in spec order with a cursor, so a verb pulls its arguments the
 * way it declared them. Each accessor checks the next slot's type and does not
 * advance on a mismatch, so a wrong pull is a recoverable error rather than a
 * fault. See include/cmd.h. */

#include "cmd.h"

struct cmd_slot {
	unsigned type;
	unsigned value;
};

static unsigned             cmd_n;
static const struct cmd_slot *cmd_slots;
static unsigned             cmd_cursor;

/* Called once from cmd_crt.S, before main, with the host-built slot vector. */
void
cmd_args_init(unsigned n, const struct cmd_slot *slots)
{
	cmd_n = n;
	cmd_slots = slots;
	cmd_cursor = 0;
}

unsigned
cmd_arg_count(void)
{
	return cmd_n;
}

void
cmd_arg_reset(void)
{
	cmd_cursor = 0;
}

unsigned
cmd_arg_peek(void)
{
	return cmd_cursor < cmd_n ? cmd_slots[cmd_cursor].type : CMD_ARG_NONE;
}

unsigned
cmd_arg_obj(void)
{
	if (cmd_cursor >= cmd_n || cmd_slots[cmd_cursor].type != CMD_ARG_OBJ)
		return VM_HANDLE_NONE;
	return cmd_slots[cmd_cursor++].value;
}

const char *
cmd_arg_str(void)
{
	if (cmd_cursor >= cmd_n || cmd_slots[cmd_cursor].type != CMD_ARG_STR)
		return 0;
	return (const char *)cmd_slots[cmd_cursor++].value;
}
