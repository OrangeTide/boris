#ifndef COMMAND_H_
#define COMMAND_H_
#include "boris.h"

void command_start(void *p, long unused2 UNUSED, void *unused3 UNUSED);

/* commands */
int command_do_character(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_chsay(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_direction(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd, const char *arg UNUSED);
int command_do_emote(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_enter(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_go(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_help(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_look(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg UNUSED);
int command_do_pose(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_quit(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg UNUSED);
int command_do_resist(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_roll(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_roomget(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_say(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_stat(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg UNUSED);
int command_do_time(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg UNUSED);
int command_do_yell(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_charset(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_chartest(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg UNUSED);
int command_do_edit(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_view(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_zone(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_dig(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_return(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg UNUSED);
int command_do_create(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_link(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_unlink(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_set(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_destroy(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_redit(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_check(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_medit(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_oedit(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_zedit(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
void command_resume(DESCRIPTOR_DATA *cl);
int command_do_grant(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd, const char *arg);
int command_do_revoke(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd, const char *arg);
int command_do_chown(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd, const char *arg);

/* In-world VFS authoring commands (src/cmd/vfscmd.c, src/cmd/fedit.c). */
int command_do_fedit(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd, const char *arg);
int command_do_fls(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd, const char *arg);
int command_do_fcat(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd, const char *arg);
int command_do_ftype(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd, const char *arg);
int command_do_fget(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd, const char *arg);
int command_do_fput(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd, const char *arg);

#endif
