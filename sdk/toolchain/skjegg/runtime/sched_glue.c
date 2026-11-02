/* sched_glue.c : the guest-facing Sleep entry point.
 *
 * Thin glue over the syscall seam (syscall_rv.S): a guest parks for a duration
 * rather than busy-spinning.  A guest reaches it through the FFI (`external
 * cdecl`), the way ReadFileStr is reached.  This is a genuine host service: on
 * skj-run it is the raw nanosleep syscall below, and on boris the host binds
 * kp_sleep_ms by name to its sys_wait(timeout) host-call, so the park policy
 * lives with the scheduler that owns the task.  A bare yield (give up the turn
 * without sleeping) is spelled Sleep(0) until coroutine scheduling lands as its
 * own namespaced unit. */

#if defined(KP_GLUE_HOSTED)
/* Expose the POSIX clock/sleep surface from <time.h> under the strict-C99 build;
   must precede every system header. */
#  if defined(__APPLE__)
#    define _DARWIN_C_SOURCE 1
#  else
#    ifndef _DEFAULT_SOURCE
#      define _DEFAULT_SOURCE 1
#    endif
#    ifndef _POSIX_C_SOURCE
#      define _POSIX_C_SOURCE 200809L
#    endif
#  endif
#endif

#include <stdint.h>

#if defined(KP_GLUE_HOSTED)

/* Hosted build (the in-process JIT and the native AOT runtime libkpaot.a): park
   through the host libc nanosleep, whose timespec has pointer-width fields on an
   LP64 host, not the 32-bit seam below. */
#include <time.h>

void
kp_sleep_ms(int ms)
{
    struct timespec req;

    if (ms < 0)
        ms = 0;
    req.tv_sec = ms / 1000;
    req.tv_nsec = (long)(ms % 1000) * 1000000L;
    (void)nanosleep(&req, (struct timespec *)0);
}

#else

/* The syscall seam (syscall_rv.S), the same wrappers libc and the Kobold
   freestanding runtime link.  nanosleep parks for a {tv_sec, tv_nsec} timespec
   (the 32-bit convention this seam and boris share). */
struct kp_timespec {
    int32_t tv_sec;
    int32_t tv_nsec;
};

extern int nanosleep(const struct kp_timespec *req, struct kp_timespec *rem);

/* Park the task for ms milliseconds.  A non-positive duration parks for no time,
   which is the plain give-up-the-turn yield. */
void
kp_sleep_ms(int ms)
{
    struct kp_timespec req;

    if (ms < 0)
        ms = 0;
    req.tv_sec = ms / 1000;
    req.tv_nsec = (ms % 1000) * 1000000;
    (void)nanosleep(&req, (struct kp_timespec *)0);
}

#endif
