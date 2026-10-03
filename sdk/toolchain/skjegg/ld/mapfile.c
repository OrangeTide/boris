/* mapfile.c : read-only memory-mapped file helpers */
/* Copyright (c) 2006, 2025-2026 Jon Mayo <jon@rm-f.net>
 * Licensed under MIT-0 OR PUBLIC DOMAIN */

#include "mapfile.h"

#if defined(_WIN32)

#define WIN32_LEAN_AND_MEAN
#include <windows.h>

int
mapfile_open(struct mapfile *mf, const char *path)
{
    mf->data = NULL;
    mf->len = 0;
    mf->hmap = NULL;

    HANDLE fh = CreateFileA(path, GENERIC_READ,
        FILE_SHARE_READ, NULL, OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL, NULL);

    if (fh == INVALID_HANDLE_VALUE) return ERR;

    LARGE_INTEGER sz;
    GetFileSizeEx(fh, &sz);
    mf->len = (size_t)sz.QuadPart;

    HANDLE hmap = CreateFileMappingA(fh, NULL,
        PAGE_READONLY, 0, 0, NULL);

    if (!hmap) {
        CloseHandle(fh);
        return ERR;
    }

    mf->data = MapViewOfFile(hmap, FILE_MAP_READ, 0, 0, 0);
    CloseHandle(fh);

    if (!mf->data) {
        CloseHandle(hmap);
        return ERR;
    }

    mf->hmap = hmap;
    return OK;
}

void
mapfile_close(struct mapfile *mf)
{
    if (mf->data) {
        UnmapViewOfFile(mf->data);
        mf->data = NULL;
    }

    if (mf->hmap) {
        CloseHandle(mf->hmap);
        mf->hmap = NULL;
    }
}

#else /* POSIX */

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>

int
mapfile_open(struct mapfile *mf, const char *path)
{
    mf->data = NULL;
    mf->len = 0;

    int fd = open(path, O_RDONLY);

    if (fd < 0) return ERR;

    struct stat sb;

    if (fstat(fd, &sb) != 0) {
        close(fd);
        return ERR;
    }

    mf->len = sb.st_size;
    void *ptr = mmap(NULL, mf->len, PROT_READ,
        MAP_PRIVATE, fd, 0);
    close(fd);

    if (ptr == MAP_FAILED) return ERR;

    mf->data = ptr;
    return OK;
}

void
mapfile_close(struct mapfile *mf)
{
    if (mf->data) {
        munmap((void *)mf->data, mf->len);
        mf->data = NULL;
    }
}

#endif
