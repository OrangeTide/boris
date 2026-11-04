#include <string.h>

void *
memcpy(void *dst, const void *src, size_t n)
{
    unsigned char *d = dst;
    const unsigned char *s = src;
    while (n--)
        *d++ = *s++;
    return dst;
}

void *
memmove(void *dst, const void *src, size_t n)
{
    unsigned char *d = dst;
    const unsigned char *s = src;
    if (d < s) {
        while (n--)
            *d++ = *s++;
    } else if (d > s) {
        d += n;
        s += n;
        while (n--)
            *--d = *--s;
    }
    return dst;
}

void *
memset(void *dst, int c, size_t n)
{
    unsigned char *d = dst;
    while (n--)
        *d++ = (unsigned char)c;
    return dst;
}

int
memcmp(const void *a, const void *b, size_t n)
{
    const unsigned char *pa = a;
    const unsigned char *pb = b;
    while (n--) {
        if (*pa != *pb)
            return (int)*pa - (int)*pb;
        pa++;
        pb++;
    }
    return 0;
}

void *
memchr(const void *s, int c, size_t n)
{
    const unsigned char *p = s;
    unsigned char ch = (unsigned char)c;
    while (n--) {
        if (*p == ch)
            return (void *)p;
        p++;
    }
    return NULL;
}

size_t
strlen(const char *s)
{
    const char *p = s;
    while (*p)
        p++;
    return (size_t)(p - s);
}

size_t
strnlen(const char *s, size_t n)
{
    size_t i = 0;
    while (i < n && s[i])
        i++;
    return i;
}

int
strcmp(const char *a, const char *b)
{
    while (*a && *a == *b) {
        a++;
        b++;
    }
    return (int)(unsigned char)*a - (int)(unsigned char)*b;
}

int
strncmp(const char *a, const char *b, size_t n)
{
    while (n && *a && *a == *b) {
        a++;
        b++;
        n--;
    }
    if (n == 0)
        return 0;
    return (int)(unsigned char)*a - (int)(unsigned char)*b;
}

char *
strcpy(char *dst, const char *src)
{
    char *d = dst;
    while ((*d++ = *src++))
        ;
    return dst;
}

char *
strncpy(char *dst, const char *src, size_t n)
{
    size_t i = 0;
    while (i < n && src[i]) {
        dst[i] = src[i];
        i++;
    }
    while (i < n)
        dst[i++] = '\0';
    return dst;
}

char *
strcat(char *dst, const char *src)
{
    char *d = dst;
    while (*d)
        d++;
    while ((*d++ = *src++))
        ;
    return dst;
}

char *
strncat(char *dst, const char *src, size_t n)
{
    char *d = dst;
    while (*d)
        d++;
    while (n && *src) {
        *d++ = *src++;
        n--;
    }
    *d = '\0';
    return dst;
}

char *
strchr(const char *s, int c)
{
    char ch = (char)c;
    for (;;) {
        if (*s == ch)
            return (char *)s;
        if (*s == '\0')
            return NULL;
        s++;
    }
}

char *
strrchr(const char *s, int c)
{
    char ch = (char)c;
    const char *last = NULL;
    for (;;) {
        if (*s == ch)
            last = s;
        if (*s == '\0')
            return (char *)last;
        s++;
    }
}

char *
strstr(const char *haystack, const char *needle)
{
    if (*needle == '\0')
        return (char *)haystack;
    for (; *haystack; haystack++) {
        const char *h = haystack;
        const char *n = needle;
        while (*h && *n && *h == *n) {
            h++;
            n++;
        }
        if (*n == '\0')
            return (char *)haystack;
    }
    return NULL;
}

size_t
strspn(const char *s, const char *set)
{
    size_t i = 0;
    for (; s[i]; i++) {
        const char *p = set;
        while (*p && *p != s[i])
            p++;
        if (*p == '\0')
            break;
    }
    return i;
}

size_t
strcspn(const char *s, const char *set)
{
    size_t i = 0;
    for (; s[i]; i++) {
        const char *p = set;
        while (*p && *p != s[i])
            p++;
        if (*p != '\0')
            break;
    }
    return i;
}

char *
strpbrk(const char *s, const char *set)
{
    for (; *s; s++) {
        const char *p = set;
        while (*p) {
            if (*p == *s)
                return (char *)s;
            p++;
        }
    }
    return NULL;
}
