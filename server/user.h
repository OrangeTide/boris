#ifndef USER_H_
#define USER_H_
struct user;

int user_init(void);
void user_shutdown(void);
void user_put(struct user **user);
void user_get(struct user *user);
int user_password_check(struct user *u, const char *cleartext);
const char *user_username(struct user *u);

#endif
