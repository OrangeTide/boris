/**
 * @file sha1crypt.h
 *
 * SHA-1 password hashing
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @date 2009 Dec 13
 *
 * Written in 2009 by Jon Mayo <jon@rm-f.net>
 *
 * To the extent possible under law, the author(s) have dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide.  This software is distributed without any warranty.
 *
 * You should have received a copy of the CC0 Public Domain Dedication along with
 * this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
 */

#ifndef SHA1CRYPT_H_
#define SHA1CRYPT_H_

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

int sha1crypt_makepass(char *buf, size_t max, const char *plaintext);
int sha1crypt_checkpass(const char *crypttext, const char *plaintext);
void sha1crypt_test(void);
#endif
