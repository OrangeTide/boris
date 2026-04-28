/* machine.h : SDK header for machine verb scripts */

#ifndef MACHINE_H
#define MACHINE_H

#include <machine_hc.h>

struct verb_reg {
	const char *name;
	void (*handler)(void);
};

#define VERB_HANDLER(vname, fn) \
	static void fn(void); \
	__attribute__((section(".data.verb_regs"), used)) \
	static const struct verb_reg _vreg_##vname = { "verb:" #vname, fn }

#define EVENT_HANDLER(ename, fn) \
	static void fn(void); \
	__attribute__((section(".data.verb_regs"), used)) \
	static const struct verb_reg _ereg_##ename = { "event:" #ename, fn }

struct verb_context {
	int          verb_fd;
	const char  *verb;
	const char  *room_id;
	const char  *player_id;
	const char  *direction;
};

#define VERB_CONTEXT ((const struct verb_context *)0x0800)

#endif /* MACHINE_H */
