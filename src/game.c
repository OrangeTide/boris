/**
 * @file game.c
 *
 * Main game initialization.
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @version 0.7
 * @date 2022 Aug 27
 *
 * Copyright (c) 2008-2022, Jon Mayo <jon@rm-f.net>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#include "game.h"
#include <login.h>
#include <boris.h>
#include <mud.h>
#include <worldclock.h>
#include <form.h>
#include <command.h>

/******************************************************************************
 * Globals
 ******************************************************************************/

/** login form and main menu. */
struct menuinfo gamemenu_login, gamemenu_main;

/******************************************************************************
 * Game - game logic
 ******************************************************************************/

/** initializes important server state */
int
game_init(void)
{
	if (worldclock_init())
		return 0;

	/*** The login menu ***/
	menu_create(&gamemenu_login, "Login Menu");

	menu_additem(&gamemenu_login, 'L', "Login", login_username_start, 0, NULL);
	menu_additem(&gamemenu_login, 'N', "New User", form_createaccount_start, 0, NULL);
	menu_additem(&gamemenu_login, 'Q', "Disconnect", signoff, 0, NULL);

	/*** The Main Menu ***/
	menu_create(&gamemenu_main, "Main Menu");
	menu_additem(&gamemenu_main, 'E', "Enter the game", command_start, 0, NULL);
	// menu_additem(&gamemenu_main, 'C', "Create Character", form_start, 0, &character_form);
	menu_additem(&gamemenu_main, 'B', "Back to login menu", menu_start, 0, &gamemenu_login);
	menu_additem(&gamemenu_main, 'Q', "Disconnect", signoff, 0, NULL);

	return 1;
}

