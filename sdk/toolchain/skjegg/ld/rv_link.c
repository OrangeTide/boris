/* rv_link.c : RISC-V relocation application over the shared layout core.
 *
 * Layout, symbol resolution and the undefined-symbol check are the shared
 * ld_layout()/ld_check_undefined() from link.c; this file supplies the
 * RISC-V relocation set, including the PCREL_HI20/PCREL_LO12 pairing (a LO12
 * takes the low 12 bits of the displacement computed at its partner AUIPC). */

#include "rv_ld.h"

#include <stdlib.h>
#include <string.h>

/****************************************************************
 * Little-endian instruction patching
 ****************************************************************/

static uint32_t
rd32(const uint8_t *p)
{
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}

static void
wr32(uint8_t *p, uint32_t v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
    p[2] = (uint8_t)(v >> 16);
    p[3] = (uint8_t)(v >> 24);
}

/* Overwrite the U-type imm[31:12] field (auipc/lui). */
static void
patch_hi20(uint8_t *p, uint32_t hi20)
{
    uint32_t w = rd32(p) & 0x00000fff;
    w |= (hi20 & 0xfffff) << 12;
    wr32(p, w);
}

/* Overwrite the I-type imm[11:0] field (addi/jalr/load). */
static void
patch_lo12_i(uint8_t *p, uint32_t lo12)
{
    uint32_t w = rd32(p) & 0x000fffff;
    w |= (lo12 & 0xfff) << 20;
    wr32(p, w);
}

/* Overwrite the S-type split immediate (store). */
static void
patch_lo12_s(uint8_t *p, uint32_t lo12)
{
    uint32_t w = rd32(p) & 0x01fff07f;
    w |= (lo12 & 0x1f) << 7;
    w |= ((lo12 >> 5) & 0x7f) << 25;
    wr32(p, w);
}

/* Overwrite the B-type branch displacement. */
static void
patch_branch(uint8_t *p, int32_t disp)
{
    uint32_t u = (uint32_t)disp;
    uint32_t w = rd32(p) & 0x01fff07f;
    w |= ((u >> 11) & 1) << 7;
    w |= ((u >> 1) & 0xf) << 8;
    w |= ((u >> 5) & 0x3f) << 25;
    w |= ((u >> 12) & 1) << 31;
    wr32(p, w);
}

/* Overwrite the J-type jump displacement. */
static void
patch_jal(uint8_t *p, int32_t disp)
{
    uint32_t u = (uint32_t)disp;
    uint32_t w = rd32(p) & 0x00000fff;
    w |= ((u >> 12) & 0xff) << 12;
    w |= ((u >> 11) & 1) << 20;
    w |= ((u >> 1) & 0x3ff) << 21;
    w |= ((u >> 20) & 1) << 31;
    wr32(p, w);
}

/* Split a value into the hi20 (with +0x800 rounding) and signed lo12 an
 * auipc/lui + addi/load pair encode. */
static void
hi_lo(uint32_t value, uint32_t *hi20, uint32_t *lo12)
{
    *hi20 = (value + 0x800) >> 12;
    *lo12 = value & 0xfff;
}

/****************************************************************
 * GOT synthesis for stock (PIE) gcc objects
 *
 * gcc defaults to -fpie, so an external symbol is reached through a GOT entry
 * (R_RISCV_GOT_HI20 on the auipc, R_RISCV_PCREL_LO12_I on the following load).
 * A static link has no dynamic loader, so we build the GOT ourselves: one
 * 4-byte entry per distinct GOT-referenced symbol, in a synthetic .got input
 * section the script places, filled after layout with the resolved absolute
 * addresses.  (GNU ld would relax these to a direct PCREL reference; we keep
 * the GOT, which is simpler and correct.)  Entries are keyed by symbol name,
 * which is exact for the globals gcc reaches through the GOT.
 ****************************************************************/

struct got_sym {
    const char *name;
    uint32_t entry_addr;
};

static struct got_sym *g_got;
static int g_ngot;

static int
got_lookup(const char *name)
{
    for (int i = 0; i < g_ngot; i++)
        if (strcmp(g_got[i].name, name) == 0)
            return i;
    return -1;
}

/* Collect the distinct GOT-referenced symbols before layout, so the .got
 * section's size (and thus the addresses of everything after it) is known. */
static void
got_prescan(struct linker *ld)
{
    g_got = NULL;
    g_ngot = 0;
    for (int oi = 0; oi < ld->nobjs; oi++) {
        struct ld_object *obj = &ld->objs[oi];
        for (int ri = 0; ri < obj->nrelocs; ri++) {
            struct ld_reloc *rel = &obj->relocs[ri];
            if (rel->type != R_RISCV_GOT_HI20)
                continue;
            const char *name = obj->syms[rel->sym_idx].name;
            if (got_lookup(name) >= 0)
                continue;
            g_got = realloc(g_got, (size_t)(g_ngot + 1) * sizeof(*g_got));
            if (!g_got)
                die("out of memory");
            g_got[g_ngot].name = name;
            g_got[g_ngot].entry_addr = 0;
            g_ngot++;
        }
    }
}

/* Append a synthetic object holding the zero-initialised .got input section,
 * so the shared layout core places it through the script's *(.got) rule. */
static void
got_inject(struct linker *ld)
{
    if (g_ngot == 0)
        return;

    uint32_t gotsize = (uint32_t)g_ngot * 4;
    struct ld_input_sec *sec = arena_zalloc(&ld->arena, sizeof(*sec));
    sec->name = ".got";
    sec->type = SHT_PROGBITS;
    sec->flags = SHF_ALLOC | SHF_WRITE;
    sec->data = arena_zalloc(&ld->arena, gotsize);
    sec->size = gotsize;
    sec->align = 4;

    struct ld_object *go = ld_add_object(ld);
    go->path = "<got>";
    go->sections = sec;
    go->nsections = 1;
}

/* After layout, fill each GOT entry with its symbol's final address and record
 * the entry address the relocations resolve against. */
static void
got_fill(struct linker *ld)
{
    if (g_ngot == 0)
        return;

    struct ld_object *go = &ld->objs[ld->nobjs - 1];
    struct ld_input_sec *sec = &go->sections[0];
    struct ld_output_sec *os = ld_find_output_sec(ld, sec);
    if (!os)
        die("the .got section was not placed (the linker script needs a"
            " '.got : { *(.got) }' output section)");

    for (int i = 0; i < g_ngot; i++) {
        uint32_t val = 0;
        int found = 0;
        for (int s = 0; s < ld->nsyms; s++) {
            if (ld->syms[s].defined
                && strcmp(ld->syms[s].name, g_got[i].name) == 0) {
                val = ld->syms[s].value;
                found = 1;
                break;
            }
        }
        if (!found)
            die("GOT symbol '%s' is undefined", g_got[i].name);
        g_got[i].entry_addr = sec->assigned_vaddr + (uint32_t)i * 4;
        uint32_t file_off = (sec->assigned_vaddr - os->vaddr) + (uint32_t)i * 4;
        wr32(os->data + file_off, val);
    }
}

/****************************************************************
 * PCREL_HI20 lookup for a PCREL_LO12 partner
 ****************************************************************/

/* Given a PCREL_LO12 whose symbol resolves to the address of its partner
 * AUIPC, find that AUIPC's PCREL_HI20 (or CALL, or GOT_HI20) relocation in the
 * same object and return the PC-relative displacement it computed.  A GOT_HI20
 * partner points at the GOT entry, not the symbol. */
static int
pcrel_hi_value(struct linker *ld, struct ld_object *obj, uint32_t auipc_addr,
               uint32_t *out)
{
    for (int ri = 0; ri < obj->nrelocs; ri++) {
        struct ld_reloc *rel = &obj->relocs[ri];
        if (rel->type != R_RISCV_PCREL_HI20
            && rel->type != R_RISCV_CALL
            && rel->type != R_RISCV_CALL_PLT
            && rel->type != R_RISCV_GOT_HI20)
            continue;
        struct ld_input_sec *isec = &obj->sections[rel->section];
        if (!isec->matched)
            continue;
        uint32_t site = isec->assigned_vaddr + rel->offset;
        if (site != auipc_addr)
            continue;
        int gi = obj->sym_map[rel->sym_idx];
        struct ld_symbol *gsym = &ld->syms[gi];
        if (rel->type == R_RISCV_GOT_HI20) {
            int gx = got_lookup(gsym->name);
            if (gx < 0)
                die("%s: GOT_HI20 for '%s' with no GOT entry",
                    obj->path, gsym->name);
            *out = g_got[gx].entry_addr - site;
        } else {
            *out = gsym->value + (uint32_t)rel->addend - site;
        }
        return 1;
    }
    return 0;
}

/****************************************************************
 * Link
 ****************************************************************/

int
rv_ld_link(struct linker *ld)
{
    got_prescan(ld);
    got_inject(ld);

    ld_layout(ld);

    got_fill(ld);

    for (int oi = 0; oi < ld->nobjs; oi++) {
        struct ld_object *obj = &ld->objs[oi];

        for (int ri = 0; ri < obj->nrelocs; ri++) {
            struct ld_reloc *rel = &obj->relocs[ri];

            /* markers carry no field to patch */
            if (rel->type == R_RISCV_RELAX || rel->type == R_RISCV_NONE)
                continue;

            /* Skip a reloc in a discarded section before resolving its
               symbol: stock objects carry SET6/SUB6/ADD/SUB pairs in
               .eh_frame, which the script drops. */
            struct ld_input_sec *isec = &obj->sections[rel->section];
            if (!isec->matched)
                continue;
            struct ld_output_sec *os = ld_find_output_sec(ld, isec);
            if (!os)
                continue;   /* the section was discarded; its relocs are moot */

            int gi = obj->sym_map[rel->sym_idx];
            if (gi < 0)
                die("%s: reloc references unmapped symbol %d",
                    obj->path, rel->sym_idx);
            struct ld_symbol *gsym = &ld->syms[gi];
            if (!gsym->defined)
                die("%s: undefined symbol '%s'", obj->path, gsym->name);

            uint32_t file_off = (isec->assigned_vaddr - os->vaddr) +
                                rel->offset;
            uint8_t *patch = os->data + file_off;

            uint32_t S = gsym->value;
            int32_t A = rel->addend;
            uint32_t P = isec->assigned_vaddr + rel->offset;
            uint32_t hi20, lo12;

            switch (rel->type) {
            case R_RISCV_32:
                wr32(patch, S + (uint32_t)A);
                break;
            case R_RISCV_32_PCREL:
                wr32(patch, S + (uint32_t)A - P);
                break;
            case R_RISCV_ADD32:
                wr32(patch, rd32(patch) + S + (uint32_t)A);
                break;
            case R_RISCV_SUB32:
                wr32(patch, rd32(patch) - (S + (uint32_t)A));
                break;

            case R_RISCV_BRANCH: {
                int32_t disp = (int32_t)(S + (uint32_t)A - P);
                if (disp < -4096 || disp > 4095)
                    die("%s: R_RISCV_BRANCH out of range for '%s' (%d)",
                        obj->path, gsym->name, disp);
                patch_branch(patch, disp);
                break;
            }
            case R_RISCV_JAL: {
                int32_t disp = (int32_t)(S + (uint32_t)A - P);
                if (disp < -1048576 || disp > 1048575)
                    die("%s: R_RISCV_JAL out of range for '%s' (%d)",
                        obj->path, gsym->name, disp);
                patch_jal(patch, disp);
                break;
            }

            case R_RISCV_HI20:
                hi_lo(S + (uint32_t)A, &hi20, &lo12);
                patch_hi20(patch, hi20);
                break;
            case R_RISCV_LO12_I:
                hi_lo(S + (uint32_t)A, &hi20, &lo12);
                patch_lo12_i(patch, lo12);
                break;
            case R_RISCV_LO12_S:
                hi_lo(S + (uint32_t)A, &hi20, &lo12);
                patch_lo12_s(patch, lo12);
                break;

            case R_RISCV_PCREL_HI20:
                hi_lo(S + (uint32_t)A - P, &hi20, &lo12);
                patch_hi20(patch, hi20);
                break;

            case R_RISCV_GOT_HI20: {
                /* auipc reaching the symbol's GOT entry (PC-relative); the
                   paired load reads the absolute address from that entry.  A
                   GOT reference carries no addend (any symbol+offset is added
                   after the load), and the partner LO12 resolves against the
                   same entry address, so both ignore A and stay consistent. */
                int gx = got_lookup(gsym->name);
                if (gx < 0)
                    die("%s: GOT_HI20 for '%s' with no GOT entry",
                        obj->path, gsym->name);
                hi_lo(g_got[gx].entry_addr - P, &hi20, &lo12);
                patch_hi20(patch, hi20);
                break;
            }

            case R_RISCV_PCREL_LO12_I:
            case R_RISCV_PCREL_LO12_S: {
                uint32_t value;
                /* S is the address of the partner AUIPC */
                if (!pcrel_hi_value(ld, obj, S + (uint32_t)A, &value))
                    die("%s: PCREL_LO12 with no matching PCREL_HI20 at %08x",
                        obj->path, S + (uint32_t)A);
                hi_lo(value, &hi20, &lo12);
                if (rel->type == R_RISCV_PCREL_LO12_I)
                    patch_lo12_i(patch, lo12);
                else
                    patch_lo12_s(patch, lo12);
                break;
            }

            case R_RISCV_CALL:
            case R_RISCV_CALL_PLT: {
                /* auipc + jalr pair patched from one displacement */
                uint32_t value = S + (uint32_t)A - P;
                hi_lo(value, &hi20, &lo12);
                patch_hi20(patch, hi20);
                patch_lo12_i(patch + 4, lo12);
                break;
            }

            default:
                die("%s: unsupported relocation type %d", obj->path,
                    rel->type);
            }
        }
    }

    ld_check_undefined(ld);

    free(g_got);                        /* leave no static state behind */
    g_got = NULL;
    g_ngot = 0;
    return 0;
}

/****************************************************************
 * Built-in RV32 user-mode linker script
 ****************************************************************/

void
rv_default_script(struct arena *a, struct ld_script *script)
{
    static const char default_script[] =
        "OUTPUT_FORMAT(\"elf32-littleriscv\")\n"
        "OUTPUT_ARCH(riscv)\n"
        "ENTRY(_start)\n"
        "MEMORY { RAM (rwx) : ORIGIN = 0x00010000, LENGTH = 0x4000000 }\n"
        "SECTIONS {\n"
        "    .text : { *(.text .text.*) } > RAM\n"
        "    .rodata : { *(.rodata .rodata.*) *(.srodata .srodata.*) } > RAM\n"
        "    .data : { *(.data .data.*) *(.sdata .sdata.*) } > RAM\n"
        "    .got : { *(.got) *(.got.plt) } > RAM\n"
        "    .bss : { __bss_start = .; *(.sbss .sbss.*) *(.bss .bss.*)"
        " *(COMMON) __bss_end = .; } > RAM\n"
        "    /DISCARD/ : { *(.note .note.*) *(.comment)"
        " *(.eh_frame) *(.gnu.hash) *(.riscv.attributes) }\n"
        "}\n";

    ld_parse_script(a, script, default_script);
}
