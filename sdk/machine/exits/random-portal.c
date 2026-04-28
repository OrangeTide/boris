/* random-portal.c : example exit script with verb:go and verb:look */
#include <machine.h>

static const char look_msg[] =
	"A shimmering portal crackles with arcane energy.\n";
static const char go_msg[] =
	"You step through the portal. Reality twists around you.\n";

VERB_HANDLER(look, on_look);
VERB_HANDLER(go, on_go);

static void
on_look(void)
{
	hc_msg_post(1, sizeof(look_msg) - 1, look_msg);
}

static void
on_go(void)
{
	hc_msg_post(1, sizeof(go_msg) - 1, go_msg);
}
