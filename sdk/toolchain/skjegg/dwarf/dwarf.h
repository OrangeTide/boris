/* dwarf.h : DWARF 4 debug-info serializer for skjegg guests.

   One serializer feeds the toolchain's debug output, independent of which
   front end produced the source-position table (every front end emits IR_LOC
   under -g; see doc/tools/debugger.md item 2).  v1 covers the line-number
   program (.debug_line): the rows (code address, source line) a backend
   collects, encoded as a DWARF 4 line-number program that readelf, addr2line,
   llvm-dwarfdump, and gdb all decode. */

#ifndef SKJ_DWARF_H
#define SKJ_DWARF_H

#include <stddef.h>
#include <stdint.h>

struct arena;

/* One row of the line table: the source line live at a code address.  Rows are
   sorted by address ascending; the address is absolute (the final link
   address, or a relocatable 0-based offset the linker fixes up).  file is the
   1-based index into the file table passed to dw_line_build (0 means file 1,
   the default), and col is the 1-based source column (0 means no column).  A
   single-file caller leaves both 0. */
struct dw_line_row {
    uint32_t addr;
    int line;
    int file;
    int col;
};

/* Serialize a DWARF 4 .debug_line program for one compilation unit.  Encodes
   the version-4 header (the files table, no extra directories) and the line
   program reproducing the rows, then DW_LNE_end_sequence at end_addr (just past
   the last instruction).  The bytes are allocated from the arena; *out points
   at them and the length is returned.  rows must be sorted by addr and
   nrows >= 1.  If set_addr_off is non-NULL it receives the byte offset, within
   the returned buffer, of the DW_LNE_set_address operand: in a relocatable
   object that address is unknown until link, so the caller places a text-base
   relocation there (R_RISCV_32, R_MIPS_32, R_68K_32, or an 8-byte
   ARM64_RELOC_UNSIGNED).  big selects big-endian multi-byte fields (ColdFire);
   0 is little-endian (RISC-V, MIPS, AArch64).  addr_size is the target address
   width, 4 (the 32-bit targets) or 8 (LP64, e.g. AArch64), and sets the width
   of the set_address operand.

   files is the file-name table (nfiles >= 1 entries, 1-based in the rows); a
   row's file index selects an entry and the program emits DW_LNS_set_file when
   it changes (a row file of 0 means file 1).  A row's col, when nonzero and
   changed, emits DW_LNS_set_column.  A single-file caller passes a one-element
   table and leaves each row's file and col at 0. */
size_t dw_line_build(struct arena *a, const char *const *files, int nfiles,
                     const struct dw_line_row *rows, int nrows,
                     uint32_t end_addr, uint8_t **out, size_t *set_addr_off,
                     int big, int addr_size);

/* Serialize the skeleton DWARF 4 .debug_abbrev table: a single abbreviation
   (code 1) describing a childless DW_TAG_compile_unit that carries producer,
   language, name, comp_dir, low_pc, high_pc, and stmt_list.  The content is
   fixed; the bytes are allocated from the arena and returned through *out. */
size_t dw_abbrev_build(struct arena *a, uint8_t **out);

/* Serialize the matching DWARF 4 .debug_info compilation unit: the CU header
   (abbrev offset 0, address size 4) and the one compile_unit DIE.  low_pc and
   high_pc (absolute) bound the unit's code, and stmt_list_off is the DIE's
   DW_AT_stmt_list, the byte offset of this unit's program in .debug_line.
   This DIE is what makes addr2line and gdb attach the line table to the unit,
   not just readelf.  The bytes are allocated from the arena.  low_pc_off and
   high_pc_off, if non-NULL, receive the byte offsets of the two 4-byte address
   operands, which in a relocatable object each take a R_RISCV_32 against the
   text base. */
size_t dw_info_build(struct arena *a, const char *producer,
                     const char *file_name, const char *comp_dir,
                     uint32_t low_pc, uint32_t high_pc,
                     uint32_t stmt_list_off, uint8_t **out,
                     size_t *low_pc_off, size_t *high_pc_off, int big,
                     int addr_size);

#endif /* SKJ_DWARF_H */
