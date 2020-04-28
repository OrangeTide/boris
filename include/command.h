#ifndef COMMAND_H_
#define COMMAND_H_
#include "boris.h"

int command_do_pose(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_yell(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_say(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_emote(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_chsay(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_quit(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg UNUSED);
int command_do_roomget(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_character(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg);
int command_do_time(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg UNUSED);
void command_start(void *p, long unused2 UNUSED, void *unused3 UNUSED);
#endif
