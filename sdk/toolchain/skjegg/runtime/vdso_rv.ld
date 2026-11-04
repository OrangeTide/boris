/* vdso_rv.ld : link the RV32 skjegg vDSO image at a fixed guest address, clear
 * of the program (0x00010000..), its heap, and the mmap area (0x70000000). The
 * host maps it here and passes the address of skj_vdso_table to the guest. The
 * entry is set to the table only to satisfy the format; it is never run. */
OUTPUT_FORMAT("elf32-littleriscv")
OUTPUT_ARCH(riscv)
ENTRY(skj_vdso_table)
MEMORY { VDSO (rx) : ORIGIN = 0x50000000, LENGTH = 0x10000 }
SECTIONS {
    .text : { *(.text .text.*) } > VDSO
    .rodata : { *(.rodata .rodata.*) *(.srodata .srodata.*) } > VDSO
    .data : { *(.data .data.*) *(.sdata .sdata.*) } > VDSO
    /DISCARD/ : { *(.note .note.*) *(.comment) *(.eh_frame)
                  *(.gnu.hash) *(.riscv.attributes)
                  *(.bss .sbss .sbss.* .bss.*) *(COMMON) }
}
