#ifndef PASSWD_H
#define PASSWD_H
struct password {
	        unsigned char salt[8], digest[20];
};

void gensalt(void *salt, size_t salt_len);
void mkpass(struct password *p, const unsigned char salt [8], const char *plaintext);
int ckpass(const struct password *a, const struct password *b);
#endif
