/* dwread.h : DWARF 4 reader for skjegg guests.

   The read side of dwarf/: one reader builds, once, an address-sorted line
   table (from .debug_line) and an address-sorted function table (from .symtab),
   then answers address lookups with no further allocation.  It feeds
   skj-addr2line, the host fault formatter in skj-run, and the backtrace
   symbolizer.  v1 reads little-endian ELF32 (the RISC-V target); a big-endian
   image is rejected rather than misread. */

#ifndef SKJ_DWREAD_H
#define SKJ_DWREAD_H

#include <stddef.h>
#include <stdint.h>

struct arena;

/* One decoded line-table row: the source position live from `addr` until the
   next row's address.  `end` marks a DW_LNE_end_sequence boundary (its address
   is one past the last instruction, and it names no live line). */
struct dw_lrow {
    uint32_t addr;
    int file;           /* index into the reader's file table */
    int line;
    int end;
};

/* One function symbol: a STT_FUNC entry from .symtab, [addr, addr+size). */
struct dw_func {
    uint32_t addr;
    uint32_t size;
    const char *name;
};

struct dw_reader {
    struct dw_lrow *lines;      /* sorted by addr ascending */
    int nlines;
    const char **files;         /* 1-based file table (files[0] unused) */
    int nfiles;
    const char *comp_dir;       /* from the CU, or NULL */
    const char *cu_name;        /* the CU's DW_AT_name, or NULL */
    struct dw_func *funcs;      /* sorted by addr ascending */
    int nfuncs;
    struct arena *arena;
};

/* Build the reader from an in-memory ELF32 image (little-endian).  Returns 0 on
   success, non-zero if the image is not a readable little-endian ELF32.  Absent
   debug or symbol sections are not an error; the matching lookups just miss.
   All tables are arena-allocated; nothing is freed per lookup. */
int dw_read_elf(struct arena *a, struct dw_reader *r,
                const uint8_t *elf, size_t len);

/* Address -> source file and line.  Returns 1 and sets *file (may be NULL) and
   *line when a covering row is found, else 0. */
int dw_lookup_line(const struct dw_reader *r, uint32_t addr,
                   const char **file, int *line);

/* Address -> the name of the containing function, or 0 if none covers it. */
int dw_lookup_func(const struct dw_reader *r, uint32_t addr,
                   const char **name);

/****************************************************************
 * Backtrace (item 5)
 *
 * The walk is decoupled from any memory source: the caller supplies a reader
 * callback, so the same code serves the emulator (gm_read_out), a core file, or
 * a unit test.  It is allocation free, so a fault handler can call it with no
 * heap in a known state.
 ****************************************************************/

/* Read `len` bytes of guest memory at `addr` into `dst`.  Returns 1 on success,
   0 if the range is not readable (the walk then stops). */
typedef int (*dw_readmem)(void *ctx, uint32_t addr, void *dst, uint32_t len);

/* Walk the RISC-V frame-pointer chain from (pc, fp) into pcs[], up to `max`
   entries.  pcs[0] is `pc` (the live instruction); each further entry is a
   caller return address read from the saved-ra slot (the backend prologue
   stores prev-fp at [fp+0] and ra at [fp+4]).  Returns the number of frames
   written.  Stops at a null or non-increasing frame pointer (so a corrupt or
   bootstrap frame ends the walk rather than looping) or an unreadable slot. */
int dw_backtrace(uint32_t pc, uint32_t fp, dw_readmem read, void *ctx,
                 uint32_t *pcs, int max);

/* Symbolize `n` frames into `buf`, one per line, bounded and NUL-terminated
   (truncated if it would overflow).  A frame reads `#N  0xADDR  func at
   file:line`, with `??` for a missing name and the `at ...` clause omitted when
   no line is known.  Frames after the first look up `addr - 1`, since a return
   address points just past its call and could land in the next line's range.
   `r` may be NULL (or an empty reader), giving raw addresses with no symbols.
   With a reader present, a caller frame whose return address lands in no known
   function ends the output with one truncation marker, so a chain that has
   wandered into garbage is trimmed rather than printed to the depth cap.
   Returns the number of frames formatted. */
int dw_backtrace_format(const struct dw_reader *r, const uint32_t *pcs, int n,
                        char *buf, size_t buflen);

#endif /* SKJ_DWREAD_H */
