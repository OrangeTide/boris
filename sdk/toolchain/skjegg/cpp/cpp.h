/* cpp.h : C preprocessor library — public API */

#ifndef CPP_H
#define CPP_H

#include <stdio.h>

struct cpp;

/* Lifecycle */
struct cpp *cpp_new(void);
void        cpp_free(struct cpp *p);

/* Configuration */
void cpp_add_include_path(struct cpp *p, const char *dir);
void cpp_define(struct cpp *p, const char *name, const char *value);
void cpp_undef(struct cpp *p, const char *name);

/* Processing — push model (for skj-cpp CLI) */
int cpp_process_file(struct cpp *p, const char *path, FILE *out);

/* Processing — pull model (for skj-cc integration) */
int         cpp_open(struct cpp *p, const char *path);
int         cpp_next_line(struct cpp *p, char *buf, int bufsize);
int         cpp_get_line_number(struct cpp *p);
const char *cpp_get_filename(struct cpp *p);

#endif /* CPP_H */
