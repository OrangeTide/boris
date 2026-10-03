/* mapfile.h : read-only memory-mapped file helpers */
/* Copyright (c) 2006, 2025-2026 Jon Mayo <jon@rm-f.net>
 * Licensed under MIT-0 OR PUBLIC DOMAIN */
#ifndef MAPFILE_H
#define MAPFILE_H

#include <stddef.h>

#ifndef OK
#define OK 0
#endif
#ifndef ERR
#define ERR (-1)
#endif

struct mapfile {
    const unsigned char *data;
    size_t len;
#if defined(_WIN32)
    void *hmap;
#endif
};

int mapfile_open(struct mapfile *mf, const char *path);
void mapfile_close(struct mapfile *mf);

#endif
