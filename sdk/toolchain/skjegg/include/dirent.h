#ifndef _DIRENT_H
#define _DIRENT_H

/* struct dirent mirrors the kernel's struct linux_dirent64, which getdents64
   fills and which is identical on every Linux architecture:

     d_ino (8) | d_off (8) | d_reclen (2) | d_type (1) | d_name[] (NUL-term)

   readdir() returns a pointer directly into the raw getdents64 buffer, so the
   fixed-field offsets below must match the kernel exactly (0, 8, 16, 18, 19);
   they do, since the two 64-bit fields sit at 0 and 8 regardless of alignment
   and the rest follow with no padding. */
struct dirent {
    unsigned long long d_ino;
    long long          d_off;
    unsigned short     d_reclen;
    unsigned char      d_type;
    char               d_name[256];
};

/* d_type file-type values (arch-independent). */
#define DT_UNKNOWN  0
#define DT_FIFO     1
#define DT_CHR      2
#define DT_DIR      4
#define DT_BLK      6
#define DT_REG      8
#define DT_LNK     10
#define DT_SOCK    12

typedef struct __dir DIR;

DIR           *opendir(const char *path);
struct dirent *readdir(DIR *dir);
int            closedir(DIR *dir);

#endif /* _DIRENT_H */
