/* invite.h : invite code system */
/* Made by a machine. PUBLIC DOMAIN (CC0-1.0) */

#ifndef INVITE_H_
#define INVITE_H_

#define INVITE_CODE_LEN 14  /* XXXX-XXXX-XXXX */

int invite_init(void);
void invite_shutdown(void);
int invite_validate(const char *code);
int invite_use(const char *code);
int invite_create_for_user(const char *username, int count);

#endif
