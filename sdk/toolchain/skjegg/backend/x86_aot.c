/* x86_aot.c : the x86-64 AOT driver.

   Provides target_emit for the LP64 x86-64 tools.  It drives the shared
   instruction selector (backend/x86_select.c) over the GNU intel-syntax text
   sink (backend/mc_text.c): the per-function machine code is the selector's, and
   this file supplies the surrounding assembly a standalone object needs, the
   extern declarations, the data globals, and the section framing.  The
   selector emits the prologue, body, and epilogue of each function; this driver
   emits the label and section directives around it.

   The 32-bit x86 tools keep backend/x86_emit.c; this driver is the x86-64 (LP64)
   replacement for that file's per-opcode switch. */

#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ir.h"
#include "mc_text.h"
#include "x86_select.h"

/****************************************************************
 * Globals
 ****************************************************************/

static void
emit_string_bytes(FILE *out, const char *s, int n)
{
    int k;

    fputs("\t.byte ", out);
    for (k = 0; k < n; k++) {
        unsigned char c = (unsigned char)s[k];
        if (k > 0)
            fputs(", ", out);
        if (c >= 0x20 && c < 0x7f && c != '\'' && c != '\\')
            fprintf(out, "'%c'", c);
        else
            fprintf(out, "0x%02x", c);
    }
    fputc('\n', out);
}

/* format a relocation operand "sym", "sym + N", or "sym - N" (the addend is a
   symbol-relative initializer's byte offset, carried in the init value word) */
static const char *
sym_ref(char *buf, size_t n, const char *sym, int64_t addend)
{
    if (addend > 0)
        snprintf(buf, n, "%s + %lld", sym, (long long)addend);
    else if (addend < 0)
        snprintf(buf, n, "%s - %lld", sym, (long long)-addend);
    else
        snprintf(buf, n, "%s", sym);
    return buf;
}

/* an aggregate global's byte image: pad to each item's offset, emit the sized
   value (8-byte low dword first, little-endian), pad to the full size */
static void
emit_init_image(FILE *out, struct ir_global *g)
{
    struct ir_init *it;
    int cur = 0;

    for (it = g->inits; it; it = it->next) {
        if (it->offset > cur) {
            fprintf(out, ".zero %d\n", it->offset - cur);
            cur = it->offset;
        }
        if (it->sym) {
            char ref[160];
            fprintf(out, "\t%s %s\n", it->size == 8 ? ".quad" : ".long",
                sym_ref(ref, sizeof ref, asm_sym(it->sym), it->ival));
        }
        else if (it->size == 8) {
            uint64_t b = (uint64_t)it->ival;
            fprintf(out, "\t.long 0x%08x\n", (unsigned)(b & 0xFFFFFFFF));
            fprintf(out, "\t.long 0x%08x\n", (unsigned)(b >> 32));
        } else if (it->size == 2)
            fprintf(out, "\t.word 0x%04x\n", (unsigned)(it->ival & 0xFFFF));
        else if (it->size == 1)
            fprintf(out, "\t.byte 0x%02x\n", (unsigned)(it->ival & 0xFF));
        else
            fprintf(out, "\t.long 0x%08x\n", (unsigned)it->ival);
        cur += it->size;
    }
    if (g->arr_size > cur)
        fprintf(out, ".zero %d\n", g->arr_size - cur);
}

/* true when a global is zero-filled (no initializer): it belongs in .bss
   (NOBITS, reserved with .zero), so its bytes cost no file space, rather than
   in .data. */
static int
global_is_bss(struct ir_global *g)
{
    return !g->inits && !g->init_string && g->init_count == 0;
}

static int
global_elsz(struct ir_global *g)
{
    switch (g->base_type) {
    case IR_I8:  return 1;
    case IR_I16: return 2;
    case IR_F64: return 8;
    case IR_I64: return 8;
    default:     return 4;
    }
}

/* natural alignment (byte count, raised by _Alignas) + global + label */
static void
emit_global_head(FILE *out, struct ir_global *g)
{
    int alb = (g->base_type == IR_F64 || g->base_type == IR_I64) ? 8 : 4;
    if (g->align > alb)
        alb = g->align;
    fprintf(out, ".align %d\n", alb);
    if (!g->is_local)
        fprintf(out, ".globl %s\n", asm_sym(g->name));
    fprintf(out, "%s:\n", asm_sym(g->name));
}

/* emit one initialized global's bytes (what follows its label) */
static void
emit_global_def(FILE *out, struct ir_global *g)
{
    int elsz = global_elsz(g);

    if (g->is_strobj) {
        /* A static Kobold string object: the {refcount, kind, len, cap} header
           in target endianness, then the text and a trailing NUL.  cap == len:
           a static string carries no spare capacity.  The header words assemble
           per-target (little-endian here), where str_core.c reads them with
           native loads. */
        fprintf(out, "\t.long 0x%08x\n", 0xffffffffu);  /* KP_RC_STATIC */
        fprintf(out, "\t.long 0x%08x\n", 1u);           /* KP_OBJ_STRING */
        fprintf(out, "\t.long %d\n", g->init_strlen);   /* byte length */
        fprintf(out, "\t.long %d\n", g->init_strlen);   /* capacity (== length) */
        if (g->init_strlen > 0)
            emit_string_bytes(out, g->init_string, g->init_strlen);
        fprintf(out, "\t.byte 0\n");                    /* trailing NUL */
    } else if (g->inits) {
        emit_init_image(out, g);
    } else if (g->init_string) {
        emit_string_bytes(out, g->init_string, g->init_strlen);
    } else {
        int k;
        for (k = 0; k < g->init_count; k++) {
            if (g->init_syms && g->init_syms[k]) {
                char ref[160];
                fprintf(out, "\t%s %s\n", elsz == 8 ? ".quad" : ".long",
                    sym_ref(ref, sizeof ref, asm_sym(g->init_syms[k]),
                            g->init_ivals[k]));
            }
            else if (g->base_type == IR_F64 || g->base_type == IR_I64) {
                uint64_t bits = (uint64_t)g->init_ivals[k];
                fprintf(out, "\t.long 0x%08x\n", (unsigned)(bits & 0xFFFFFFFF));
                fprintf(out, "\t.long 0x%08x\n", (unsigned)(bits >> 32));
            } else if (elsz == 1)
                fprintf(out, "\t.byte %" PRId64 "\n", g->init_ivals[k]);
            else if (elsz == 2)
                fprintf(out, "\t.word %" PRId64 "\n", g->init_ivals[k]);
            else
                fprintf(out, "\t.long %" PRId64 "\n", g->init_ivals[k]);
        }
        if (g->arr_size > g->init_count)
            fprintf(out, "\t.zero %d\n",
                (g->arr_size - g->init_count) * elsz);
    }
}

static void
emit_globals(FILE *out, struct ir_program *prog)
{
    struct ir_global *g;
    int any_bss = 0;
    int any_ro = 0;

    fputs("\n.data\n", out);
    for (g = prog->globals; g; g = g->next) {
        if (global_is_bss(g)) {
            any_bss = 1;
            continue;
        }
        if (g->is_rodata) {
            any_ro = 1;
            continue;
        }
        emit_global_head(out, g);
        emit_global_def(out, g);
    }

    /* initialized, read-only globals (const): same bytes, .rodata section */
    if (any_ro) {
        fputs("\n.section .rodata\n", out);
        for (g = prog->globals; g; g = g->next) {
            if (global_is_bss(g) || !g->is_rodata)
                continue;
            emit_global_head(out, g);
            emit_global_def(out, g);
        }
    }

    if (!any_bss)
        return;

    /* Zero-filled globals: .bss reserves them with .zero (NOBITS), no file
       space. */
    fputs("\n.bss\n", out);
    for (g = prog->globals; g; g = g->next) {
        int elsz = global_elsz(g);
        int sz;

        if (!global_is_bss(g))
            continue;
        emit_global_head(out, g);
        sz = (g->arr_size > 0) ? g->arr_size * elsz : elsz;
        fprintf(out, "\t.zero %d\n", sz);
    }
}

/****************************************************************
 * Extern declarations
 *
 * GNU `as` treats every undefined symbol as external, so no `.extern`
 * declaration is needed.  The scan is kept (it is cheap and documents the
 * symbol set) but emits nothing.
 ****************************************************************/

static void
emit_extern_once(FILE *out, struct strset *seen, const char *sym)
{
    (void)out;
    strset_add(seen, sym);      /* keep the dedup set; emit no directive */
}

static void
emit_externs(FILE *out, struct ir_program *prog)
{
    struct ir_func *fn;
    struct ir_global *g;
    struct ir_insn *i;
    struct strset defined, seen;

    /* Every symbol the module defines, so a reference to one is not wrongly
       declared extern.  Built once into a set: a per-reference linear scan of
       the function and global lists was quadratic in program size (kpcom has
       ~1250 symbols and ~8000 referencing instructions, and that scan was the
       front end's single hottest spot). */
    strset_init(&defined);
    for (fn = prog->funcs; fn; fn = fn->next)
        strset_add(&defined, fn->name);
    for (g = prog->globals; g; g = g->next)
        strset_add(&defined, g->name);

    strset_init(&seen);
    for (fn = prog->funcs; fn; fn = fn->next) {
        for (i = fn->head; i; i = i->next) {
            if (i->sym &&
                (i->op == IR_CALL || i->op == IR_TAILCALL ||
                 i->op == IR_FCALL || i->op == IR_CALL64 ||
                 i->op == IR_CALL_AGG || i->op == IR_CALL2 ||
                 i->op == IR_LEA || i->op == IR_LEA64)) {
                /* a symbol-address load (IR_LEA/LEA64) can reference an external
                   data symbol; the defined set filters out the program's own
                   globals and functions.  IR_CALL2 is the failable call, so a
                   cross-unit `fails` routine is covered too (the scan is kept
                   for its structure; emit_extern_once prints nothing) */
                if (!strset_contains(&defined, i->sym))
                    emit_extern_once(out, &seen, i->sym);
            }
            switch (i->op) {
            case IR_FLH:
                emit_extern_once(out, &seen, "__skj_extendhfsf");
                break;
            case IR_FSH:
                emit_extern_once(out, &seen, "__skj_truncsfhf");
                break;
            case IR_CAPTURE:
                emit_extern_once(out, &seen, "__cont_capture");
                break;
            case IR_RESUME:
                emit_extern_once(out, &seen, "__cont_resume");
                break;
            case IR_MARK:
                emit_extern_once(out, &seen, "__cont_mark_sp");
                emit_extern_once(out, &seen, "__cont_arena_ptr");
                break;
            case IR_CONT_UNWIND:
                emit_extern_once(out, &seen, "__cont_arena_ptr");
                break;
            default:
                break;
            }
        }
    }

    /* Under the guarded policy the selector emits a divide guard and a checked
       arithmetic overflow branch that call these trap helpers directly (sink
       helpers, not IR calls, so the scan above does not reach them).  With GNU
       `as` they need no declaration; the calls resolve as undefined externals. */
    if (target_aot_trap_guarded) {
        emit_extern_once(out, &seen, "kp_trap_overflow");
        emit_extern_once(out, &seen, "kp_trap_div_zero");
    }

    strset_free(&seen);
    strset_free(&defined);
}

/****************************************************************
 * Entry point
 ****************************************************************/

void
target_emit(FILE *out, struct ir_program *prog)
{
    struct ir_func *fn;
    struct mc *m;
    int serial = 0;

    fputs(".intel_syntax noprefix\n", out);
    fputs("# generated x86-64 (LP64) assembly, GNU intel syntax\n", out);
    emit_externs(out, prog);

    m = mct_new(out);
    if (!m) {
        fputs("x86_aot: out of memory\n", stderr);
        exit(1);
    }
    for (fn = prog->funcs; fn; fn = fn->next) {
        char err[128];
        int rc;

        fputs("\n.text\n", out);
        if (!fn->is_local)
            fprintf(out, ".globl %s\n", asm_sym(fn->name));
        fprintf(out, "%s:\n", asm_sym(fn->name));

        mct_begin_func(m, ++serial);
        rc = x86_select_func(m, fn,
                             target_aot_trap_guarded ? TRAP_GUARDED : TRAP_HARDWARE,
                             err, sizeof err);
        if (rc != 0) {
            fprintf(stderr, "x86_aot: %s\n", err);
            exit(1);
        }
        if (mct_errsym(m)) {
            fprintf(stderr, "x86_aot: unresolved symbol '%s'\n", mct_errsym(m));
            exit(1);
        }
    }
    mct_free(m);

    emit_globals(out, prog);
    /* mark the stack non-executable so the GNU linker does not warn (and
       default to an executable stack) about the missing note */
    fputs("\n.section .note.GNU-stack,\"\",@progbits\n", out);
}
