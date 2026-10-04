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
#include <command.h>

/******************************************************************************
 * Globals
 ******************************************************************************/

/******************************************************************************
 * Game - game logic
 ******************************************************************************/

/** initializes important server state. The login and main menus are now on
 * the interactive UI layer (login_ui.c), built per connection. */
int
game_init(void)
{
	if (worldclock_init())
		return 0;

	return 1;
}

/** free game state. */
void
game_shutdown(void)
{
}

