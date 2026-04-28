#ifndef MACHINE_HC_H
#define MACHINE_HC_H

#include <stddef.h>

/* HC_ABORT (0): terminate with exit_status = -1 */
static inline void __attribute__((noreturn))
hc_abort(void)
{
	__asm__ volatile (".word 0xA000");
	__builtin_unreachable();
}

/* HC_EXIT (4): terminate with given status */
static inline void __attribute__((noreturn))
hc_exit(int status)
{
	register int _st __asm__("d0") = status;
	__asm__ volatile (".word 0xA004" :: "d"(_st));
	__builtin_unreachable();
}

/* HC_YIELD (2): yield the current time slice */
static inline void
hc_yield(void)
{
	__asm__ volatile (".word 0xA002");
}

/* HC_SLEEP (3): sleep for the given number of ticks */
static inline void
hc_sleep(int ticks)
{
	register int _t __asm__("d0") = ticks;
	__asm__ volatile (".word 0xA003" :: "d"(_t) : "memory");
}

/* HC_PRINT (5): debug print (len bytes from buf) */
static inline int
hc_print(size_t len, const char *buf)
{
	register int _len __asm__("d0") = (int)len;
	register const char *_buf __asm__("a0") = buf;
	__asm__ volatile (".word 0xA005"
		: "+d"(_len) : "a"(_buf) : "memory");
	return _len;
}

/* HC_OPEN (6): open a handle (verb, event, etc.) */
static inline int
hc_open(const char *name, int flags, void (*handler)(void))
{
	register int _flags __asm__("d0") = flags;
	register int _handler __asm__("d1") = (int)(unsigned long)handler;
	register const char *_name __asm__("a0") = name;
	__asm__ volatile (".word 0xA006"
		: "+d"(_flags) : "d"(_handler), "a"(_name) : "memory");
	return _flags;
}

/* HC_CLOSE (7): close a handle, returns kind enum */
static inline int
hc_close(int fd)
{
	register int _fd __asm__("d0") = fd;
	__asm__ volatile (".word 0xA007"
		: "+d"(_fd) :: "memory");
	return _fd;
}

/* HC_WAIT (8): wait for handles or timeout */
static inline int
hc_wait(int ncount, unsigned short *handles, int timeout_ms)
{
	register int _n __asm__("d0") = ncount;
	register int _timeout __asm__("d1") = timeout_ms;
	register unsigned short *_handles __asm__("a0") = handles;
	__asm__ volatile (".word 0xA008"
		: "+d"(_n) : "d"(_timeout), "a"(_handles) : "memory");
	return _n;
}

/* HC_MSG_POST (19): post message to a file descriptor */
static inline int
hc_msg_post(int fd, size_t len, const char *buf)
{
	register int _fd __asm__("d0") = fd;
	register int _len __asm__("d1") = (int)len;
	register const char *_buf __asm__("a0") = buf;
	__asm__ volatile (".word 0xA013"
		: "+d"(_fd) : "d"(_len), "a"(_buf) : "memory");
	return _fd;
}

#endif /* MACHINE_HC_H */
