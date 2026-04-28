#include <machine.h>

static const char msg[] = "The fountain bubbles softly.\n";

int
main(void)
{
	for (;;) {
		hc_msg_post(1, sizeof(msg) - 1, msg);
		hc_wait(0, (void *)0, 10000);
	}
}
