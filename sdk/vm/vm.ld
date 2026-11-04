/* vm.ld : linker script for VM guest programs.
 *
 * A flat 128KB image matching the runtime in src/vm: code and data from
 * 0x400 (0x0-0x3FF left for host use), the stack set by the host growing down
 * from 0x20000. Adapted from skjegg's RV32 runtime linker script. The assembler
 * merges everything into .text/.rodata/.data/.bss, so there is no separate
 * .text.entry input; ENTRY(_start) names the entry point instead. */

OUTPUT_FORMAT("elf32-littleriscv")
OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY
{
    RAM (rwx) : ORIGIN = 0x00000400, LENGTH = 0x1FC00
}

SECTIONS
{
    .text : {
        *(.text .text.*)
    } > RAM

    .rodata : {
        *(.rodata .rodata.*)
    } > RAM

    .data : {
        *(.data .data.*)
    } > RAM

    .bss : {
        __bss_start = .;
        *(.bss .bss.*)
        *(COMMON)
        __bss_end = .;
    } > RAM
}
