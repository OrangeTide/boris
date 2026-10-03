/* internal.h : C preprocessor library — private data structures */

#ifndef CPP_INTERNAL_H
#define CPP_INTERNAL_H

#include "cpp.h"
#include <stddef.h>

/* PP-token kinds */
enum pp_tok {
    PP_EOF = 0,
    PP_IDENT,
    PP_NUMBER,
    PP_STRING,
    PP_CHAR,
    PP_PUNCT,
    PP_SPACE,
    PP_NEWLINE,
    PP_PLACEMARKER,
};

struct pp_token {
    int kind;
    char *text;
    int len;
    int blue;
    struct pp_token *next;
};

/* Macro definition */
struct cpp_macro {
    char *name;
    int is_func;
    int nparams;
    int is_variadic;
    char **params;
    struct pp_token *body;
    int builtin;
    int expanding;
    struct cpp_macro *next;
};

/* Builtin macro IDs */
enum {
    BUILTIN_NONE = 0,
    BUILTIN_FILE,
    BUILTIN_LINE,
    BUILTIN_DATE,
    BUILTIN_TIME,
    BUILTIN_STDC,
    BUILTIN_STDC_VERSION,
};

#define CPP_HTAB_SIZE 256

/* Conditional stack */
struct cpp_cond {
    int active;
    int seen_true;
    int is_else;
    struct cpp_cond *up;
};

/* Include file stack */
struct cpp_file {
    const char *path;
    char *buf;
    const char *pos;
    int line;
    struct cpp_file *up;
};

/* Main preprocessor state */
struct cpp {
    struct cpp_macro *macros[CPP_HTAB_SIZE];
    struct cpp_cond *cond;
    struct cpp_file *file;
    const char **include_paths;
    int ninclude_paths;
    int include_paths_cap;
    char *date_str;
    char *time_str;
    char linebuf[8192];
    char outbuf[8192];
    int errors;
    int in_comment;
};

/* tok.c */
struct pp_token *pp_tokenize(const char *line, int len);
void             pp_free_tokens(struct pp_token *list);
struct pp_token *pp_token_dup(struct pp_token *tok);
struct pp_token *pp_list_dup(struct pp_token *list);
int              pp_detokenize(struct pp_token *list, char *buf, int bufsize);

/* macro.c */
void             macro_define(struct cpp *p, const char *name,
                              struct pp_token *body, int is_func,
                              int nparams, char **params, int is_variadic);
void             macro_undef(struct cpp *p, const char *name);
struct cpp_macro *macro_lookup(struct cpp *p, const char *name);
struct pp_token *macro_expand(struct cpp *p, struct pp_token *input);

/* cond.c */
long long        cond_eval(struct cpp *p, struct pp_token *expr);
void             cond_push(struct cpp *p, int active);
void             cond_pop(struct cpp *p);
int              cond_active(struct cpp *p);

/* A hard preprocessing error: prints "skj-cpp: error: ..." and increments
 * p->errors, which cpp_process_file turns into a nonzero exit.  Unlike warn(),
 * it fails the run, for constraint violations the C standard requires a
 * diagnostic for (#error, an unbalanced conditional, and so on). */
void             cpp_error(struct cpp *p, const char *fmt, ...);

/* dir.c */
int              dir_process_line(struct cpp *p, const char *line, int len,
                                  FILE *out);

#include "util.h"

#endif /* CPP_INTERNAL_H */
