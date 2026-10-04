#ifndef GAME_H_
#define GAME_H_
#include "mud.h"

/* Interactive UI-layer menus/forms (replace gamemenu_login / gamemenu_main
 * and the old form.c new-user flow). */
void login_ui_open(DESCRIPTOR_DATA *cl);
void main_ui_open(DESCRIPTOR_DATA *cl);
void newuser_ui_open(DESCRIPTOR_DATA *cl);

int game_init(void);
void game_shutdown(void);
#endif
