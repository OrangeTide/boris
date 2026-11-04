/* kp_io.h : the Kobold console I/O seam (the POSIX-fd model).

   The front end lowers write/writeln/read/readln to these io_* symbols with an fd
   stream argument: fd 1 is standard output, fd 2 standard error, and input is
   stdin (fd 0).  kp_io.c is the single implementation shared by the hosted
   runtime (kp_host.c) and the freestanding runtime (io_free.c).  Every
   conversion routes through the shared C-runtime number formatters
   (libc/numfmt.c): integer output through __fmt_udec and real output through
   __fmt_greal, the same formatters the C libc's %g path uses.  Each value's
   bytes reach the fd with a plain write, with no stream buffering. */
#ifndef KP_IO_H
#define KP_IO_H

#include "str.h"

#include <stdint.h>

void    io_write_str(int fd, kp_gptr s);
void    io_write_int(int fd, int v);
void    io_write_char(int fd, int ch);
void    io_write_real(int fd, double x);
void    io_flush(int fd);
void    io_halt(int code);

int64_t io_read_int(void);
double  io_read_real(void);
int     io_read_char(void);
void    io_read_ln(void);
kp_gptr io_read_str(void);
int     io_eof(void);

#endif
