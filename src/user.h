#ifndef USER_H_
#define USER_H_
#include <time.h>

#define USER_LASTLOGINS_MAX 5

struct user;

struct login_record {
    time_t time;
    char peer[46];
    int success;
};

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
const char *user_extra_get(struct user *u, const char *name);
int user_extra_set(struct user *u, const char *name, const char *value);
int user_save(struct user *u);

int user_is_locked(struct user *u);
const char *user_lockout_text(struct user *u);
void user_lock(struct user *u, const char *reason);
void user_unlock(struct user *u);

void user_record_login(struct user *u, const char *peer, int success);
const struct login_record *user_lastlogins(struct user *u, unsigned *count);

void user_login_count_inc(struct user *u);
void user_login_count_dec(struct user *u);
unsigned user_login_count(struct user *u);

unsigned user_total_logins(struct user *u);
time_t user_since(struct user *u);
#endif
