/* cas-codec.c : compile-time compression codec table for CAS */
/* Made by a machine. PUBLIC DOMAIN (CC0-1.0) */

#include "cas-codec.h"
#include "cas.h"

#include <stdlib.h>
#include <string.h>

/****************************************************************
 * The codec table
 ****************************************************************
 *
 * Built at compile time from an X-macro list.  CAS_CODEC_NONE is
 * intrinsic (handled in the wrappers below) and appears only as a
 * placeholder so the array is never empty.  The bundled DEFLATE
 * codec is added under -DCAS_WITH_MINIZ; an application may add
 * its own by defining CAS_CODEC_USER (see cas-codec.h).
 */

#ifdef CAS_WITH_MINIZ
int cas_deflate_decode(const void *in, size_t inlen,
                       void *out, size_t outlen);
int cas_deflate_encode(const void *in, size_t inlen,
                       void *out, size_t *outlen);
#define CAS_CODEC_MINIZ(X) \
    X(CAS_CODEC_DEFLATE, cas_deflate_decode, cas_deflate_encode, "deflate")
#else
#define CAS_CODEC_MINIZ(X)
#endif

#ifndef CAS_CODEC_USER
#define CAS_CODEC_USER(X)
#endif

#define CAS_CODEC_LIST(X) \
    CAS_CODEC_MINIZ(X) \
    CAS_CODEC_USER(X)

static const struct cas_codec codec_table[] = {
    { CAS_CODEC_NONE, NULL, NULL, "none", },
#define X(tag, dec, enc, nm) { (tag), (dec), (enc), (nm), },
    CAS_CODEC_LIST(X)
#undef X
};

static const struct cas_codec *
codec_find(int tag)
{
    size_t n = sizeof(codec_table) / sizeof(codec_table[0]);

    for (size_t i = 0; i < n; i++)
        if (codec_table[i].tag == tag)
            return &codec_table[i];
    return NULL;
}

/****************************************************************
 * Compression policy
 ****************************************************************/

/* Does the prefix look like text?  Binary is flagged by too many
 * C0 control bytes other than the usual whitespace; high-bit bytes
 * are allowed so UTF-8 counts as text. */
static int
looks_text(const void *data, size_t len)
{
    const unsigned char *p = data;

    if (len == 0)
        return 0;

    size_t n = len < CAS_TEXT_SNIFF ? len : CAS_TEXT_SNIFF;
    size_t nontext = 0;

    for (size_t i = 0; i < n; i++) {
        unsigned char c = p[i];

        if (c <= 0x08 || (c >= 0x0e && c <= 0x1f) || c == 0x7f)
            nontext++;
    }

    return nontext * 100 <= n * CAS_TEXT_MAX_NONTEXT_PCT;
}

int
cas_codec_policy(int policy, int codec, const void *data, size_t len)
{
    switch (policy) {
    case CAS_COMPRESS_ALWAYS:
        return codec;
    case CAS_COMPRESS_GUESS:
        return looks_text(data, len) ? codec : CAS_CODEC_NONE;
    case CAS_COMPRESS_NEVER:
    default:
        return CAS_CODEC_NONE;
    }
}

/****************************************************************
 * Lookup wrappers
 ****************************************************************/

int
cas_codec_supported(int codec)
{
    const struct cas_codec *c;

    if (codec == CAS_CODEC_NONE)
        return 1;
    c = codec_find(codec);
    return c && c->decode;
}

int
cas_codec_can_encode(int codec)
{
    const struct cas_codec *c;

    if (codec == CAS_CODEC_NONE)
        return 1;
    c = codec_find(codec);
    return c && c->encode;
}

int
cas_codec_decode(int codec, const void *in, size_t inlen,
                 void *out, size_t outlen)
{
    const struct cas_codec *c;

    if (codec == CAS_CODEC_NONE) {
        if (inlen != outlen)
            return CAS_ERR;
        if (outlen)
            memcpy(out, in, outlen);
        return CAS_OK;
    }

    c = codec_find(codec);
    if (!c || !c->decode)
        return CAS_ETYPE;

    return c->decode(in, inlen, out, outlen);
}

int
cas_codec_encode(int codec, const void *in, size_t inlen,
                 void *out, size_t *outlen)
{
    const struct cas_codec *c;

    if (codec == CAS_CODEC_NONE) {
        if (*outlen < inlen)
            return CAS_ERR;
        if (inlen)
            memcpy(out, in, inlen);
        *outlen = inlen;
        return CAS_OK;
    }

    c = codec_find(codec);
    if (!c || !c->encode)
        return CAS_ETYPE;

    return c->encode(in, inlen, out, outlen);
}

/****************************************************************
 * Object region decode
 ****************************************************************/

int
cas_codec_region_decode(const unsigned char *region, size_t region_size,
                        int framed, size_t plaintext_len,
                        const unsigned char **data, size_t *len,
                        unsigned char **owned)
{
    *owned = NULL;

    if (!framed) {
        /* legacy raw object: the region is the plaintext */
        if (region_size != plaintext_len)
            return CAS_ERR;
        *data = plaintext_len ? region : NULL;
        *len = plaintext_len;
        return CAS_OK;
    }

    /* v2: [ codec tag(1) | payload ] */
    if (region_size < 1)
        return CAS_ERR;

    int codec = region[0];
    const unsigned char *payload = region + 1;
    size_t payload_len = region_size - 1;

    if (codec == CAS_CODEC_NONE) {
        if (payload_len != plaintext_len)
            return CAS_ERR;
        *data = plaintext_len ? payload : NULL;
        *len = plaintext_len;
        return CAS_OK;
    }

    if (plaintext_len == 0) {
        /* nothing to decode; an empty object is never compressed */
        *data = NULL;
        *len = 0;
        return CAS_OK;
    }

    /* bound inflation so a crafted header cannot force a huge
     * allocation (the plaintext length is not covered by the
     * address on an untrusted read) */
    if (payload_len == 0 ||
        plaintext_len > CAS_CODEC_MAX_PLAINTEXT ||
        plaintext_len / payload_len > CAS_CODEC_MAX_RATIO)
        return CAS_ERR;

    unsigned char *buf = malloc(plaintext_len);

    if (!buf)
        return CAS_ENOMEM;

    int rc = cas_codec_decode(codec, payload, payload_len, buf,
                              plaintext_len);

    if (rc != CAS_OK) {
        free(buf);
        return rc;
    }

    *data = buf;
    *len = plaintext_len;
    *owned = buf;
    return CAS_OK;
}
