/* ui_telnet.c : wire a UI session to a telnetclient descriptor (spec 10) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#include "ui.h"
#include <boris.h>
#include "telnetclient.h"

/* line input from the descriptor is forwarded to the controller. */
static void
ui_line_cb(DESCRIPTOR_DATA *cl, const char *line)
{
	ui_input_line(telnetclient_get_ui(cl), line);
}

/* free-on-disconnect: drop the session without running user callbacks. */
static void
ui_free_cb(DESCRIPTOR_DATA *cl)
{
	struct ui_session *s = telnetclient_get_ui(cl);

	if (s) {
		telnetclient_set_ui(cl, NULL);
		ui_session_free(s);
	}
}

void
ui_resume_input(DESCRIPTOR_DATA *cl)
{
	telnetclient_start_lineinput(cl, ui_line_cb, mud_config.menu_prompt);
}

void
ui_open(DESCRIPTOR_DATA *cl, struct ui_frame *frame,
	void (*on_close)(DESCRIPTOR_DATA *cl))
{
	struct ui_session *s;

	telnetclient_clear_statedata(cl);	/* fresh state */
	/* Capability selection (spec 8.1) grows to MXP/web later; the text
	 * renderer is the universal fallback and the only one so far. */
	s = ui_session_new(&ui_render_text, cl, on_close, frame);
	if (!s)
		return;
	telnetclient_set_ui(cl, s);
	telnetclient_set_state_free(cl, ui_free_cb);
	telnetclient_start_lineinput(cl, ui_line_cb, mud_config.menu_prompt);
}
