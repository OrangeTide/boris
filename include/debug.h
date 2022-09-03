/**
 * @file debug.h
 *
 * Debug Macros
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @date 2022 Aug 17
 *
 * Copyright (c) 2009-2022 Jon Mayo <jon@rm-f.net>
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

#ifndef DEBUG_H_
#define DEBUG_H_
#include <stdio.h>
#include <errno.h>
#include "log.h"
#if defined(NTRACE) || defined(NDEBUG)
#  include "util.h"
#endif

#ifndef NTRACE
/** TRACE() prints a message to stderr if NTRACE is not defined. */
#  define TRACE(f, ...) LOG_TRACE("%s():%u:" f, __func__, __LINE__, __VA_ARGS__)
#else
#  define TRACE(...) /* TRACE disabled */
#endif

#ifndef NDEBUG
#  define HEXDUMP(data, len, ...) do { LOG_DEBUG(__VA_ARGS__); util_hexdump(stderr, data, len); } while(0)
#else
#  define HEXDUMP(data, len, ...) /* HEXDUMP disabled */
#endif

#ifndef NTRACE
#  define HEXDUMP_TRACE(data, len, ...) do { LOG_TRACE(__VA_ARGS__); util_hexdump(stderr, data, len); } while(0)
#else
#  define HEXDUMP_TRACE(data, len, ...) /* HEXDUMP disabled */
#endif

/** trace logs entry to a function if NTRACE is not defined. */
#define TRACE_ENTER() LOG_TRACE("%s():%u:ENTER\n", __func__, __LINE__)

/** trace logs exit of a function if NTRACE is not defined. */
#define TRACE_EXIT() LOG_TRACE("%s():%u:EXIT\n", __func__, __LINE__)

/** tests an expression, if failed prints an error message based on errno and jumps to a label. */
#define FAILON(e, reason, label) do { if(e) { LOG_ERROR("FAILED:%s:%s", reason, strerror(errno)); goto label; } } while(0)

/** logs a message based on errno */
#define PERROR(msg) LOG_ERROR("%s():%d:%s:%s", __func__, __LINE__, msg, strerror(errno))

/** DIE - print the function and line number then abort. */
#define DIE() do { LOG_ERROR("abort!"); abort(); } while(0)

#ifndef NDEBUG
#include <string.h>
/** initialize with junk - used to find unitialized values. */
#  define JUNKINIT(ptr, len) memset((ptr), 0xBB, (len))
#else
#  define JUNKINIT(ptr, len) /* do nothing */
#endif
#endif
