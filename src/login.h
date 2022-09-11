#ifndef LOGIN_H_
#define LOGIN_H_
#include <boris.h>
#include <mud.h>

void login_password_lineinput(DESCRIPTOR_DATA *cl, const char *line);
void login_password_start(void *p, long unused2, void *unused3);
void login_username_lineinput(DESCRIPTOR_DATA *cl, const char *line);
void login_username_start(void *p, long unused2, void *unused3);
void signoff(void *p, long unused2, void *unused3);
#endif
