/* test.h : minimal unit test harness */
/* Copyright (c) 2026 Jon Mayo <jon@rm-f.net>
 * Licensed under BSD-2-Clause-Patent OR MIT */

#ifndef TEST_H
#define TEST_H

#include <stdio.h>
#include <string.h>

static int t_count;
static int t_fail;

#define ASSERT(cond) do { \
    t_count++; \
    if (!(cond)) { \
        t_fail++; \
        fprintf(stderr, "  FAIL %s:%d: %s\n", \
                __FILE__, __LINE__, #cond); \
    } \
} while (0)

#define ASSERT_INT_EQ(a, b) do { \
    int _t_a = (a), _t_b = (b); \
    t_count++; \
    if (_t_a != _t_b) { \
        t_fail++; \
        fprintf(stderr, "  FAIL %s:%d: %s == %d, expected %d\n", \
                __FILE__, __LINE__, #a, _t_a, _t_b); \
    } \
} while (0)

#define ASSERT_STR_EQ(a, b) do { \
    const char *_t_a = (a), *_t_b = (b); \
    t_count++; \
    if (!_t_a || !_t_b || strcmp(_t_a, _t_b) != 0) { \
        t_fail++; \
        fprintf(stderr, "  FAIL %s:%d: %s == \"%s\", expected \"%s\"\n", \
                __FILE__, __LINE__, #a, \
                _t_a ? _t_a : "(null)", \
                _t_b ? _t_b : "(null)"); \
    } \
} while (0)

#define RUN(fn) do { \
    int _t_f = t_fail; \
    fn(); \
    if (t_fail == _t_f) \
        fprintf(stderr, "  pass: %s\n", #fn); \
    else \
        fprintf(stderr, "  FAILED: %s\n", #fn); \
} while (0)

#define TEST_REPORT() do { \
    fprintf(stderr, "%d assertions, %d failures\n", t_count, t_fail); \
    return t_fail ? 1 : 0; \
} while (0)

#endif /* TEST_H */
