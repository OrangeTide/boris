/** Number of bits used by SHA-1 */
#define SHA1CRYPT_BITS 128

/** default length of salt to use for salted hash. */
#define SHA1CRYPT_GENSALT_LEN 6

/** maximum salt size we support. */
#define SHA1CRYPT_GENSALT_MAX 16

/** prefix for salted SHA1 password hash. */
#define SHA1PASSWD_MAGIC "{SSHA}"

/** length of SHA1PASSWD_MAGIC. */
#define SHA1PASSWD_MAGIC_LEN 6

/** maximum length of crypted password including null termination. */
#define SHA1PASSWD_MAX (SHA1PASSWD_MAGIC_LEN+((SHA1_DIGEST_LENGTH+SHA1CRYPT_GENSALT_MAX+3)/4*4)*4/3+1)

/* sha1crypt.c */
int sha1crypt_makepass(char *buf, size_t max, const char *plaintext);
int sha1crypt_checkpass(const char *crypttext, const char *plaintext);
void sha1crypt_test(void);
