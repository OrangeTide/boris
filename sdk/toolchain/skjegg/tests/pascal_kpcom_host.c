/* Host import shims for kpcom built by skj-pc with KOBOLD defined.  With
   KOBOLD its file I/O is `external cdecl`, so the acceptance test links these
   host functions in place of the Kobold runtime's own.  A Pascal string is a
   managed descriptor (refcount, kind, len, cap, bytes); NULL is the empty
   string.  The directory helpers back the `uses ns.*` namespace wildcard:
   kpd_open returns a small handle (or -1), kpd_next the next entry name ('' at
   the end), kpd_close releases it, over the host opendir/readdir, mirroring the
   Kobold runtime's own kpd_* in aot_rt.c. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>

#define PSTR_HDR 16

void *__pascal_str_new(const char *b, int len);

static int pstr_len(const void *s)
{
    if (!s) return 0;
    return *(const int *)((const char *)s + 8);
}

static const char *pstr_bytes(const void *s)
{
    if (!s) return "";
    return (const char *)s + PSTR_HDR;
}

void *ReadFileStr(const void *path)
{
    char p[4096];
    int n = pstr_len(path);
    FILE *f;
    long sz;
    char *buf;
    void *r;
    if (n >= (int)sizeof(p)) n = sizeof(p) - 1;
    memcpy(p, pstr_bytes(path), n);
    p[n] = '\0';
    f = fopen(p, "rb");
    if (!f) return __pascal_str_new("", 0);
    fseek(f, 0, SEEK_END);
    sz = ftell(f);
    fseek(f, 0, SEEK_SET);
    buf = malloc(sz > 0 ? sz : 1);
    if (sz > 0) sz = fread(buf, 1, sz, f);
    fclose(f);
    r = __pascal_str_new(buf, (int)sz);
    free(buf);
    return r;
}

int WriteFileStr(const void *path, const void *data)
{
    char p[4096];
    int n = pstr_len(path);
    FILE *f;
    size_t w;
    if (n >= (int)sizeof(p)) n = sizeof(p) - 1;
    memcpy(p, pstr_bytes(path), n);
    p[n] = '\0';
    f = fopen(p, "wb");
    if (!f) return 0;
    w = fwrite(pstr_bytes(data), 1, pstr_len(data), f);
    fclose(f);
    return (int)w == pstr_len(data);
}

#define KPD_MAX 16
static DIR *kpd_tab[KPD_MAX];

int kpd_open(const void *path)
{
    char p[4096];
    int n = pstr_len(path);
    int i;
    if (n >= (int)sizeof(p)) n = sizeof(p) - 1;
    memcpy(p, pstr_bytes(path), n);
    p[n] = '\0';
    for (i = 0; i < KPD_MAX; i++)
        if (!kpd_tab[i])
            break;
    if (i == KPD_MAX)
        return -1;
    kpd_tab[i] = opendir(p);
    return kpd_tab[i] ? i : -1;
}

void *kpd_next(int handle)
{
    struct dirent *e;
    if (handle < 0 || handle >= KPD_MAX || !kpd_tab[handle])
        return __pascal_str_new("", 0);
    e = readdir(kpd_tab[handle]);
    if (!e)
        return __pascal_str_new("", 0);
    return __pascal_str_new(e->d_name, (int)strlen(e->d_name));
}

void kpd_close(int handle)
{
    if (handle >= 0 && handle < KPD_MAX && kpd_tab[handle]) {
        closedir(kpd_tab[handle]);
        kpd_tab[handle] = 0;
    }
}
