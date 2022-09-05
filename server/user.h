#ifndef USER_H_
#define USER_H_
struct user;

int user_illegal(const char *username);
int user_exists(const char *username);
struct user *user_lookup(const char *username);
struct user *user_create(const char *username, const char *password, const char *email);
int user_password_check(struct user *u, const char *cleartext);
const char *user_username(struct user *u);
int user_init(void);
void user_shutdown(void);
void user_put(struct user **user);
void user_get(struct user *user);
#endif
