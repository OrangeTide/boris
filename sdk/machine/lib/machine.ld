OUTPUT_FORMAT("elf32-m68k")
OUTPUT_ARCH(m68k)
ENTRY(_start)

MEMORY
{
    RAM (rwx) : ORIGIN = 0x1000, LENGTH = 60K
}

PHDRS
{
    text PT_LOAD FLAGS(7);
}

SECTIONS
{
    .text : {
        *(.text .text.*)
        *(.rodata .rodata.*)
    } > RAM : text

    .data : {
        *(.data .data.*)
    } > RAM : text

    .data.verb_regs : {
        __verb_regs_start = .;
        *(.data.verb_regs)
        __verb_regs_end = .;
    } > RAM : text

    .bss : {
        __bss_start = .;
        *(.bss .bss.*)
        *(COMMON)
        __bss_end = .;
    } > RAM : text

    /DISCARD/ : {
        *(.note .note.*)
        *(.comment)
        *(.eh_frame)
        *(.gnu.hash)
    }
}
