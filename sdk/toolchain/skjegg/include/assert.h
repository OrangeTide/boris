/* assert.h is intentionally not guarded against re-inclusion: NDEBUG may be
   defined or undefined between includes, which must re-expand the macro. */
#undef assert

void __assert_fail(const char *expr, const char *file, int line,
                   const char *func);

#ifdef NDEBUG
#define assert(e) ((void)0)
#else
#define assert(e) \
    ((e) ? (void)0 : __assert_fail(#e, __FILE__, __LINE__, __func__))
#endif

/* C11 7.2p3: the static_assert macro expands to _Static_assert. skj-cc also
   accepts static_assert as a keyword, so this only pins the standard spelling. */
#define static_assert _Static_assert
