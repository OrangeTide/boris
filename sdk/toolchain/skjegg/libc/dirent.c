/* opendir / readdir / closedir over the getdents64 syscall (the crt wrapper in
   runtime/syscall_rv.S, syscall_cf.S, and the start_*.S for the other arches).
   A DIR holds one getdents64 buffer; readdir walks it entry by entry, refilling
   from the kernel when it runs out, and returns a pointer into the buffer. */
#include <dirent.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

#ifdef SKJ_FS_INTERPOSE

/* fs/ interposition: a directory is an fs fd opened with FS_O_DIRECTORY and
   iterated by fs_read, which yields fixed fs_dirent records.  readdir copies
   one into a struct dirent the caller sees.  opendir/readdir/closedir are the
   thin per-language wrapper the fs/ layer expects over fs_open/fs_read/fs_close. */
#include "fs.h"

struct __dir {
    int           fd;                   /* the fs fd for the open directory */
    struct dirent de;                   /* the entry handed back to the caller */
};

DIR *
opendir(const char *path)
{
    DIR *dir;
    int fd = fs_open(path, FS_O_DIRECTORY | FS_O_RDONLY, 0);

    if (fd < 0)
        return 0;
    dir = (DIR *)malloc(sizeof(DIR));
    if (!dir) {
        fs_close(fd);
        return 0;
    }
    dir->fd = fd;
    return dir;
}

struct dirent *
readdir(DIR *dir)
{
    struct fs_dirent fe;

    if (!dir)
        return 0;
    if (fs_read(dir->fd, &fe, (int)sizeof fe) != (int)sizeof fe)
        return 0;                       /* 0 at end, negative on error */
    dir->de.d_ino = fe.ino;
    dir->de.d_off = 0;
    dir->de.d_reclen = (unsigned short)sizeof(struct dirent);
    dir->de.d_type = (fe.type == FS_DT_DIR) ? DT_DIR
                   : (fe.type == FS_DT_REG) ? DT_REG : DT_UNKNOWN;
    {
        int i = 0;
        while (i < (int)sizeof dir->de.d_name - 1 && fe.name[i]) {
            dir->de.d_name[i] = fe.name[i];
            i++;
        }
        dir->de.d_name[i] = 0;
    }
    return &dir->de;
}

int
closedir(DIR *dir)
{
    int r;
    if (!dir)
        return -1;
    r = fs_close(dir->fd);
    free(dir);
    return r;
}

#else /* raw getdents64 path */

#define DIRBUF 4096

/* buf is first so it inherits the allocation's alignment; the kernel packs
   entries at an 8-byte stride, so every entry lands aligned. */
struct __dir {
    char buf[DIRBUF];
    int  fd;
    int  pos;                   /* next unread byte in buf */
    int  len;                   /* valid bytes in buf */
};

DIR *
opendir(const char *path)
{
    DIR *dir;
    int fd = open(path, O_RDONLY, 0);

    if (fd < 0)
        return 0;
    dir = (DIR *)malloc(sizeof(DIR));
    if (!dir) {
        close(fd);
        return 0;
    }
    dir->fd = fd;
    dir->pos = 0;
    dir->len = 0;
    return dir;
}

struct dirent *
readdir(DIR *dir)
{
    struct dirent *de;

    if (!dir)
        return 0;
    if (dir->pos >= dir->len) {
        int n = getdents64(dir->fd, dir->buf, DIRBUF);
        if (n <= 0)              /* 0 at end of directory, <0 on error */
            return 0;
        dir->len = n;
        dir->pos = 0;
    }
    de = (struct dirent *)(dir->buf + dir->pos);
    dir->pos += de->d_reclen;
    return de;
}

int
closedir(DIR *dir)
{
    int r;

    if (!dir)
        return -1;
    r = close(dir->fd);
    free(dir);
    return r;
}

#endif /* SKJ_FS_INTERPOSE */
