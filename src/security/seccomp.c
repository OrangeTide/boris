/**
 * @file seccomp.c
 *
 * seccomp-bpf syscall filter for Linux 3.5+.
 *
 * Blocks dangerous syscalls (exec, ptrace, module loading, mount,
 * reboot, namespace manipulation) after initialization. Uses a
 * deny-list so normal server operation is unaffected.
 *
 * Copyright (c) 2026, Jon Mayo <jon@rm-f.net>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#ifdef __linux__

#include <errno.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <sys/prctl.h>
#include <sys/syscall.h>
#include <unistd.h>

#define LOG_SUBSYSTEM "security"
#include <log.h>

#ifndef SECCOMP_MODE_FILTER
#define SECCOMP_MODE_FILTER 2
#endif

#define SC_RET_KILL_PROCESS 0x80000000U
#define SC_RET_ERRNO        0x00050000U
#define SC_RET_ALLOW        0x7FFF0000U

struct sc_filter {
	uint16_t code;
	uint8_t jt;
	uint8_t jf;
	uint32_t k;
};

struct sc_fprog {
	unsigned short len;
	struct sc_filter *filter;
};

/* BPF_LD|BPF_W|BPF_ABS */
#define SC_LOAD_ABS(off)        { 0x20, 0, 0, (off) }
/* BPF_JMP|BPF_JEQ|BPF_K */
#define SC_JEQ(val, jt, jf)     { 0x15, (jt), (jf), (val) }
/* BPF_RET|BPF_K */
#define SC_RET(val)             { 0x06, 0, 0, (val) }

/* offsets into struct seccomp_data */
#define SD_OFF_NR   0
#define SD_OFF_ARCH 4

#if defined(__x86_64__)
#define NATIVE_AUDIT_ARCH 0xC000003EU
#elif defined(__aarch64__)
#define NATIVE_AUDIT_ARCH 0xC00000B7U
#elif defined(__arm__)
#define NATIVE_AUDIT_ARCH 0x40000028U
#else
#define NATIVE_AUDIT_ARCH 0
#endif

static const int denied_syscalls[] = {
	__NR_execve,
#ifdef __NR_execveat
	__NR_execveat,
#endif
	__NR_ptrace,
	__NR_init_module,
#ifdef __NR_finit_module
	__NR_finit_module,
#endif
	__NR_delete_module,
	__NR_mount,
	__NR_umount2,
	__NR_pivot_root,
	__NR_chroot,
	__NR_reboot,
#ifdef __NR_kexec_load
	__NR_kexec_load,
#endif
#ifdef __NR_kexec_file_load
	__NR_kexec_file_load,
#endif
	__NR_unshare,
	__NR_setns,
#ifdef __NR_ioperm
	__NR_ioperm,
#endif
#ifdef __NR_iopl
	__NR_iopl,
#endif
};

#define NR_DENIED (sizeof(denied_syscalls) / sizeof(denied_syscalls[0]))
#define FILTER_LEN (3 + 1 + NR_DENIED + 1 + 1)

int
security_seccomp_apply(void)
{
	struct sc_filter filter[FILTER_LEN];
	struct sc_fprog prog;
	unsigned i, j = 0;

	if (NATIVE_AUDIT_ARCH == 0) {
		LOG_INFO("seccomp: unsupported architecture, skipping");
		return 0;
	}

	/* load architecture from seccomp_data */
	filter[j++] = (struct sc_filter)SC_LOAD_ABS(SD_OFF_ARCH);
	/* kill on architecture mismatch (blocks 32-bit compat syscalls) */
	filter[j++] = (struct sc_filter)SC_JEQ(NATIVE_AUDIT_ARCH, 1, 0);
	filter[j++] = (struct sc_filter)SC_RET(SC_RET_KILL_PROCESS);
	/* load syscall number */
	filter[j++] = (struct sc_filter)SC_LOAD_ABS(SD_OFF_NR);
	/* deny-list: jump to deny on match, fall through to next check */
	for (i = 0; i < NR_DENIED; i++) {
		filter[j++] = (struct sc_filter)SC_JEQ(
			(uint32_t)denied_syscalls[i],
			(uint8_t)(NR_DENIED - i), 0);
	}
	/* default: allow */
	filter[j++] = (struct sc_filter)SC_RET(SC_RET_ALLOW);
	/* deny: return EPERM */
	filter[j++] = (struct sc_filter)SC_RET(SC_RET_ERRNO | EPERM);

	prog.len = (unsigned short)j;
	prog.filter = filter;

	if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog) < 0) {
		if (errno == EINVAL || errno == ENOSYS) {
			LOG_INFO("seccomp: not supported by this kernel");
			return 0;
		}
		LOG_ERROR("seccomp: PR_SET_SECCOMP: %s", strerror(errno));
		return -1;
	}

	LOG_INFO("seccomp: syscall filter active (%u rules)",
	         (unsigned)NR_DENIED);
	return 0;
}

#else /* !__linux__ */

int
security_seccomp_apply(void)
{
	return 0;
}

#endif
