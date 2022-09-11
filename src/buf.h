#ifndef BUF_H_
#define BUF_H_
#include <stddef.h>
#include <stdbool.h>

struct buf;

struct buf *buf_new(void);
void buf_free(struct buf *b);
bool buf_check(struct buf *b);
void buf_append(struct buf *b, char v);
void buf_write(struct buf *b, const void *data, size_t len);
size_t buf_read(struct buf *b, void *data, size_t maxlen);
void *buf_data(struct buf *b, size_t *len_out);
void *buf_reserve(struct buf *b, size_t *len_out, size_t minlen);
void buf_commit(struct buf *b, size_t addlen);
bool buf_consume(struct buf *b, size_t len);
#endif
