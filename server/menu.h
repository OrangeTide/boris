#ifndef MENU_H_
#define MENU_H_
#include <stddef.h>
#include <mud.h>
#include <list.h>

/** structure that defined an item in a menu. */
struct menuitem {
	LIST_ENTRY(struct menuitem) item;
	char *name;
	char key;
	void (*action_func)(void *p, long extra2, void *extra3);
	long extra2;
	void *extra3;
};

/** defines a menu. */
struct menuinfo {
	LIST_HEAD(struct, struct menuitem) items;
	char *title;
	size_t title_width;
	struct menuitem *tail;
};

void menu_create(struct menuinfo *mi, const char *title);
void menu_additem(struct menuinfo *mi, int ch, const char *name, void (*func )(void *,long,void *), long extra2, void *extra3);
void menu_titledraw(DESCRIPTOR_DATA *cl, const char *title, size_t len);
void menu_show(DESCRIPTOR_DATA *cl, const struct menuinfo *mi);
void menu_input(DESCRIPTOR_DATA *cl, const struct menuinfo *mi, const char *line);
void menu_start(void *p, long unused2, void *extra3);
void menu_start_input(DESCRIPTOR_DATA *cl, const struct menuinfo *menu);
#endif
