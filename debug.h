/**
 * @file debug.h
 *
 * Debug Macros
 *
 * @author Jon Mayo <jon.mayo@gmail.com>
 * @date 2019 Nov 21
 *
 * Copyright (c) 2009-2019 Jon Mayo
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * The views and conclusions contained in the software and documentation are
 * those of the authors and should not be interpreted as representing official
 * policies, either expressed or implied, of the Boris MUD project.
 */
#ifndef DEBUG_H_
#define DEBUG_H_
/* VERBOSE(), DEBUG() and TRACE() macros.
 * DEBUG() does nothing if NDEBUG is defined
 * TRACE() does nothing if NTRACE is defined */
#include <stdio.h>
#include <errno.h>

/** log a message to the console. */
#define VERBOSE(...) fprintf(stderr, __VA_ARGS__)

#ifdef NDEBUG
#  define DEBUG(...) /* DEBUG disabled */
#  define DEBUG_MSG(msg) /* DEBUG_MSG disabled */
#  define HEXDUMP(data, len, ...) /* HEXDUMP disabled */
#else

/** DEBUG() prints a formatted message to stderr if NDEBUG is not defined. */
#  define DEBUG(msg, ...) fprintf(stderr, "DEBUG:%s():%d:" msg, __func__, __LINE__, ## __VA_ARGS__);

/** DEBUG_MSG prints a string and newline to stderr if NDEBUG is not defined. */
#  define DEBUG_MSG(msg) fprintf(stderr, "DEBUG:%s():%d:" msg "\n", __func__, __LINE__);

/** HEXDUMP() outputs a message and block of hexdump data to stderr if NDEBUG is not defined. */
#  define HEXDUMP(data, len, ...) do { fprintf(stderr, __VA_ARGS__); util_hexdump(stderr, data, len); } while(0)
#endif

#ifdef NTRACE
#  define TRACE(...) /* TRACE disabled */
#  define HEXDUMP_TRACE(data, len, ...) /* HEXDUMP_TRACE disabled */
#else
/** TRACE() prints a message to stderr if NTRACE is not defined. */
#  define TRACE(f, ...) fprintf(stderr, "TRACE:%s():%u:" f, __func__, __LINE__, __VA_ARGS__)
/** HEXDUMP_TRACE() does a hexdump to stderr if NTRACE is not defined. */
#  define HEXDUMP_TRACE(data, len, ...) HEXDUMP(data, len, __VA_ARGS__)
#endif


/** TRACE_MSG() prints a message and newline to stderr if NTRACE is not defined. */
#define TRACE_MSG(m) TRACE("%s\n", m);

/** ERROR_FMT() prints a formatted message to stderr. */
#define ERROR_FMT(msg, ...) fprintf(stderr, "ERROR:%s():%d:" msg, __func__, __LINE__, __VA_ARGS__);

/** ERROR_MSG prints a string and newline to stderr. */
#define ERROR_MSG(msg) fprintf(stderr, "ERROR:%s():%d:" msg "\n", __func__, __LINE__);

/** TODO prints a string and newline to stderr. */
#define TODO(msg) fprintf(stderr, "TODO:%s():%d:" msg "\n", __func__, __LINE__);

/** trace logs entry to a function if NTRACE is not defined. */
#define TRACE_ENTER() TRACE("%u:ENTER\n", __LINE__);

/** trace logs exit of a function if NTRACE is not defined. */
#define TRACE_EXIT() TRACE("%u:EXIT\n", __LINE__);

/** tests an expression, if failed prints an error message based on errno and jumps to a label. */
#define FAILON(e, reason, label) do { if(e) { fprintf(stderr, "FAILED:%s:%s\n", reason, strerror(errno)); goto label; } } while(0)

/** logs a message based on errno */
#define PERROR(msg) fprintf(stderr, "ERROR:%s():%d:%s:%s\n", __func__, __LINE__, msg, strerror(errno));

/** DIE - print the function and line number then abort. */
#define DIE() do { ERROR_MSG("abort!"); abort(); } while(0)

#ifndef NDEBUG
#include <string.h>
/** initialize with junk - used to find unitialized values. */
#  define JUNKINIT(ptr, len) memset((ptr), 0xBB, (len));
#else
#  define JUNKINIT(ptr, len) /* do nothing */
#endif
#endif
