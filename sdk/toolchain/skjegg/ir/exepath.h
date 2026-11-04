/* exepath.h : find the directory holding the running executable.

   A relocated toolchain resolves its headers and per-target runtime relative to
   its own location (so an installed copy needs no environment set) rather than
   from the build-tree path baked in at compile time.  Header only (static), so
   the host drivers that want it (cc/main.c, driver/main.c) just include it; no
   extra object to link. */

#ifndef SKJ_EXEPATH_H
#define SKJ_EXEPATH_H

#include <string.h>
#include <unistd.h>
#if defined(__APPLE__)
#include <mach-o/dyld.h>
#include <stdint.h>
#endif

/* Fill `out` (cap bytes) with the directory of the running executable, or "" if
   it cannot be determined.  Prefers the kernel's own path (/proc/self/exe on
   Linux, _NSGetExecutablePath on macOS), so it is right however the program was
   started: an absolute path, a relative one, or a bare name found on PATH.
   Falls back to argv[0] when that carries a directory component. */
static void
skj_exe_dir(const char *argv0, char *out, size_t cap)
{
    char path[4096];
    const char *src = argv0;
    const char *slash;
    size_t d;

    path[0] = '\0';
    /* The kernel-path lookup is a host-tool convenience and uses readlink /
       _NSGetExecutablePath, which the self-hosting skjegg libc does not provide.
       Under __skj__ (this TU is being compiled by skj-cc, so it links that
       libc) skip it and fall back to argv[0]; a relocated install is a host
       feature, and the guest-built compiler resolves headers from the baked or
       env path instead. */
#if defined(__linux__) && !defined(__skj__)
    {
        ssize_t n = readlink("/proc/self/exe", path, sizeof path - 1);
        if (n > 0)
            path[n] = '\0';
        else
            path[0] = '\0';
    }
#elif defined(__APPLE__) && !defined(__skj__)
    {
        uint32_t sz = sizeof path;
        if (_NSGetExecutablePath(path, &sz) != 0)
            path[0] = '\0';
    }
#endif
    if (path[0])
        src = path;

    out[0] = '\0';
    if (!src)
        return;
    slash = strrchr(src, '/');
    if (!slash)
        return;                         /* a bare name and no kernel path: give up */
    d = (size_t)(slash - src);
    if (d >= cap)
        d = cap - 1;
    memcpy(out, src, d);
    out[d] = '\0';
}

#endif /* SKJ_EXEPATH_H */
