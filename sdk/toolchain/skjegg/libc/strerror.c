#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <stddef.h>

/* A message per errno code, indexed by the number.  The order matches the
   codes in <errno.h> (EDOM is 1, through ENOSPC at 10); index 0 is success. */
static const char *const messages[] = {
    "Success",
    "Numerical argument out of domain",         /* EDOM   */
    "Numerical result out of range",            /* ERANGE */
    "Invalid or incomplete multibyte character",/* EILSEQ */
    "Invalid argument",                         /* EINVAL */
    "Cannot allocate memory",                   /* ENOMEM */
    "No such file or directory",                /* ENOENT */
    "Bad file descriptor",                      /* EBADF  */
    "Input/output error",                       /* EIO    */
    "Permission denied",                        /* EACCES */
    "No space left on device",                  /* ENOSPC */
};

char *
strerror(int err)
{
    if (err >= 0 && (size_t)err < sizeof messages / sizeof messages[0])
        return (char *)messages[err];
    return (char *)"Unknown error";
}

void
perror(const char *s)
{
    if (s && *s) {
        fputs(s, stderr);
        fputs(": ", stderr);
    }
    fputs(strerror(errno), stderr);
    fputc('\n', stderr);
}
