#ifndef BORIS_FDB_H_
#define BORIS_FDB_H_
struct fdb_write_handle;
struct fdb_read_handle;
struct fdb_iterator;

int fdb_initialize(void);
void fdb_shutdown(void);
int fdb_domain_init(const char *domain);
struct fdb_write_handle *fdb_write_begin(const char *domain, const char *id);
struct fdb_write_handle *fdb_write_begin_uint(const char *domain, unsigned id);
int fdb_write_pair(struct fdb_write_handle *h, const char *name, const char *value_str);
int fdb_write_format(struct fdb_write_handle *h, const char *name, const char *value_fmt, ...);
int fdb_write_end(struct fdb_write_handle *h);
void fdb_write_abort(struct fdb_write_handle *h);
struct fdb_read_handle *fdb_read_begin(const char *domain, const char *id);
struct fdb_read_handle *fdb_read_begin_uint(const char *domain, unsigned id);
int fdb_read_next(struct fdb_read_handle *h, const char **name, const char **value);
int fdb_read_end(struct fdb_read_handle *h);
struct fdb_iterator *fdb_iterator_begin(const char *domain);
const char *fdb_iterator_next(struct fdb_iterator *it);
void fdb_iterator_end(struct fdb_iterator *it);
#endif
