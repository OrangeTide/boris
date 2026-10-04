/* login_ui.c : the login menu on the interactive UI layer */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#include "ui.h"
#include <boris.h>
#include "telnetclient.h"
#include "login.h"
#include "command.h"
#include "game.h"

/*
 * Menu-item actions hand the descriptor to the existing login flows. Each
 * clears the UI state first (which frees this session), so cl is captured
 * before the clear and the session is not touched afterwards.
 */
static void
act_login(struct ui_session *s, void *ctx)
{
	DESCRIPTOR_DATA *cl = s->cl;

	(void)ctx;
	telnetclient_clear_statedata(cl);	/* frees this UI session */
	login_username_start(cl, 0, NULL);
}

static void
act_newuser(struct ui_session *s, void *ctx)
{
	DESCRIPTOR_DATA *cl = s->cl;

	(void)ctx;
	telnetclient_clear_statedata(cl);	/* frees this UI session */
	newuser_ui_open(cl);
}

/* Quit=Disconnect: the last frame pops and on_close signs the client off. */
static void
login_on_close(DESCRIPTOR_DATA *cl)
{
	signoff(cl, 0, NULL);
}

/* Shared, read-only frame. Per-connection state lives in the ui_session, so
 * one static frame safely serves every connection; it owns nothing (free is
 * NULL) and is never popped-and-freed. */
static struct ui_field login_fields[] = {
	{ .label = "Login",    .type = UI_ACTION, .on_select = act_login },
	{ .label = "New User", .type = UI_ACTION, .on_select = act_newuser },
};

static struct ui_frame login_frame = {
	.title = "Login Menu",
	.fields = login_fields,
	.nr_fields = 2,
	.action_mask = UI_A(UI_ACT_QUIT),
};

void
login_ui_open(DESCRIPTOR_DATA *cl)
{
	ui_open(cl, &login_frame, login_on_close);
}

/* --- main menu (post-login) ------------------------------------------ */

static void
act_enter(struct ui_session *s, void *ctx)
{
	DESCRIPTOR_DATA *cl = s->cl;

	(void)ctx;
	telnetclient_clear_statedata(cl);	/* frees this UI session */
	command_start(cl, 0, NULL);		/* enter the game */
}

static void
act_back(struct ui_session *s, void *ctx)
{
	DESCRIPTOR_DATA *cl = s->cl;

	(void)ctx;
	login_ui_open(cl);			/* ui_open clears this session */
}

/* Quit=Disconnect at the main menu. */
static void
main_on_close(DESCRIPTOR_DATA *cl)
{
	signoff(cl, 0, NULL);
}

static struct ui_field main_fields[] = {
	{ .label = "Enter the game",    .type = UI_ACTION, .on_select = act_enter },
	{ .label = "Back to login menu", .type = UI_ACTION, .on_select = act_back },
};

static struct ui_frame main_frame = {
	.title = "Main Menu",
	.fields = main_fields,
	.nr_fields = 2,
	.action_mask = UI_A(UI_ACT_QUIT),
};

void
main_ui_open(DESCRIPTOR_DATA *cl)
{
	ui_open(cl, &main_frame, main_on_close);
}
