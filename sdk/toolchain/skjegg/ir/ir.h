/* ir.h : portable compiler IR data structures, builder API, and shared declarations */

#ifndef IR_H
#define IR_H

#include <inttypes.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

#include "arena.h"
#include "util.h"

/****************************************************************
 * Base types
 ****************************************************************/

enum ir_basetype {
    IR_I32 = 1,
    IR_I8  = 2,
    IR_I16 = 3,
    IR_F64 = 4,
    IR_I64 = 5,
    IR_F32 = 6,
};

/*
 * Float opcode width tag.  The floating-point opcodes (IR_FADD .. IR_FCALLI,
 * IR_ITOF/IR_FTOI, the F-loads/stores and F-slots) carry their precision in
 * the instruction's `imm` field: FWIDTH_F32 means single precision, anything
 * else (the default 0, or 8) means double.  F32 and F64 temps share the fp
 * register class, so only instruction selection differs; the two cross-width
 * conversions are IR_F32TOF64 / IR_F64TOF32.
 */
#define FWIDTH_F32 4

/****************************************************************
 * IR opcodes
 ****************************************************************/

/*
 * Integer width and the address-cleanliness invariant.
 *
 * The IR is ILP32 by default: a pointer is a 32-bit value, the same width as
 * an int, so one set of ops (IR_ADD, IR_LEA, IR_ADL, ...) serves both integer
 * arithmetic and address arithmetic.  A separate 64-bit set (IR_ADD64,
 * IR_LEA64, IR_ADL64, and the other *64 opcodes) is emitted only when a front
 * end runs LP64, where a pointer is 64-bit and differs in width from an int.
 * So the value-versus-address distinction is carried by the opcode's width,
 * not by a separate "address add" opcode.
 *
 * INVARIANT: an i32-producing op must leave the high 32 bits of its result
 * zero.  The 64-bit backends keep every address as a zero-extended 32-bit
 * value in a register and form the real pointer only at the load or store, so
 * an i32 result may next be an operand of a 64-bit address computation
 * (base + index).  If a 32-bit op leaves garbage above bit 31 (a carry from
 * ADD, a sign fill from NEG/NOT, a shifted bit from SHL), that address add
 * reads it and the access lands out of range.  A backend satisfies the
 * invariant by emitting each i32 op at 32-bit width: on x86-64 and AArch64 a
 * 32-bit operation zeroes the upper half of its destination register.  The
 * 32-bit targets (ColdFire, RISC-V RV32, MIPS, x86-32) get it for free since
 * the register is 32 bits wide.  This is not optional: it is what makes one
 * ILP32 IR_ADD correct for both a value and an address.
 */
enum ir_op {
    IR_NOP,
    IR_LIC,
    IR_LEA,
    IR_ADL,
    IR_MOV,

    IR_ADD, IR_SUB, IR_MUL,
    IR_DIVS, IR_DIVU, IR_MODS, IR_MODU,
    IR_AND, IR_OR, IR_XOR,
    IR_SHL, IR_SHRS, IR_SHRU,
    IR_NEG, IR_NOT,

    IR_LB, IR_LBS, IR_LH, IR_LHS, IR_LW,
    IR_SB, IR_SH, IR_SW,

    IR_LDL, IR_STL,
    IR_ALLOCA,

    IR_CMPEQ, IR_CMPNE,
    IR_CMPLTS, IR_CMPLES, IR_CMPGTS, IR_CMPGES,
    IR_CMPLTU, IR_CMPLEU, IR_CMPGTU, IR_CMPGEU,

    IR_JMP, IR_BZ, IR_BNZ,

    IR_ARG,
    IR_FARG,
    IR_CALL,
    IR_CALLI,
    IR_TAILCALL,
    IR_TAILCALLI,
    IR_RET, IR_RETV,

    IR_FUNC, IR_ENDF, IR_LABEL,

    IR_MARK, IR_CAPTURE, IR_RESUME, IR_CONT_UNWIND,

    IR_FADD, IR_FSUB, IR_FMUL, IR_FDIV,
    IR_FNEG, IR_FABS,
    /* f64 -> f64 square root; a float def.  No backend lowers it yet. */
    IR_FSQRT,

    IR_FCMPEQ, IR_FCMPLT, IR_FCMPLE,

    IR_ITOF, IR_FTOI,
    /* f64 -> i32, round to nearest.  Consumes a float and produces an int, so
       its result is a normal int def, not a float def.  Not yet lowered. */
    IR_FROUND,
    IR_F32TOF64, IR_F64TOF32,

    IR_FLS, IR_FLD,
    IR_FSS, IR_FSD,
    IR_FLH, IR_FSH,
    IR_FLDL, IR_FSTL,

    IR_FRETV,
    IR_FCALL, IR_FCALLI,

    IR_LIC64,
    IR_ADD64, IR_SUB64, IR_MUL64,
    /* 64-bit signed/unsigned divide and modulo.  i64 defs (a register pair on
       the 32-bit targets).  Not yet lowered by any backend. */
    IR_DIVS64, IR_DIVU64, IR_MODS64, IR_MODU64,
    IR_AND64, IR_OR64, IR_XOR64,
    IR_SHL64, IR_SHRS64, IR_SHRU64,
    IR_NEG64,

    IR_CMP64EQ, IR_CMP64NE,
    IR_CMP64LTS, IR_CMP64LES, IR_CMP64GTS, IR_CMP64GES,
    IR_CMP64LTU, IR_CMP64LEU, IR_CMP64GTU, IR_CMP64GEU,

    IR_LD64, IR_ST64,
    IR_LDL64, IR_STL64,

    /* 64-bit address roots (LP64): a symbol / local-slot address as a full
       64-bit value.  Only emitted by cc under LP64; the ILP32 targets use the
       32-bit IR_LEA / IR_ADL. */
    IR_LEA64, IR_ADL64,

    /* va_start: initialize the va_list whose address is in operand `a` from
       the current function's SysV register save area and stack args.  The
       backend owns the frame layout, so it fills the four fields. */
    IR_VA_START,

    IR_SEXT64, IR_ZEXT64, IR_TRUNC64,

    IR_ARG64,
    IR_RETV64,
    IR_CALL64, IR_CALLI64,

    /* aggregate (struct-by-value) return and call result for the psABI
       register classification: RETV_AGG packs the struct at [a] into the
       return registers (using fn->ret_cls); CALL_AGG / CALLI_AGG make the
       call and store the returned eightbytes into slot (imm encodes the
       eightbyte count and classes) */
    IR_RETV_AGG,
    IR_CALL_AGG, IR_CALLI_AGG,

    /* a MEMORY-class (>16 byte) struct argument passed by value: a = the
       struct's address, imm = its byte size; the caller copies it onto the
       stack.  A MEMORY return uses a hidden pointer, an ordinary leading
       integer parameter cc adds, so it needs no new opcode. */
    IR_ARG_MEM,

    /* AAPCS64: the indirect-result pointer for a memory-class struct return,
       placed in x8 (a = the result address) rather than a normal arg register */
    IR_ARG_X8,

    /* basic inline assembly: sym holds the verbatim asm text (one string, the
       body of an asm(...) statement).  A backend emits it as-is.  It is an
       opaque barrier: no operands, no register allocation, no scheduling. */
    IR_ASM,

    /* Checked signed 32-bit arithmetic: dst = a OP b, trapping OVERFLOW when
       the result overflows.  A normal i32 def (in neither classifier).  Not
       yet emitted by any front end or lowered by any backend; the JIT selector
       (jit/) handles them.  Anchored right after IR_ASM so their values match
       the kobold JIT, which shares this IR. */
    IR_ADDO, IR_SUBO, IR_MULO,

    /* Source-line marker (imm = the line).  Produces no code and defines no
       value; a backend that tracks debug info records the current output
       position against the line.  The source file is carried once per function
       in ir_func.src_file, not repeated here.  Emitted by a front end under -g
       (cc, kobold) and observed by every backend: the selector sinks record it
       (a comment in the AOT text sink, an address-to-line entry in the JIT byte
       sink), the direct ColdFire and MIPS emitters currently skip it. */
    IR_LOC,

    /* two-integer return: the value plus a second result (an error signal) in a
       second return register, the ABI for a failable routine (see the Kobold
       front end, doc/languages/kobold/kp-errors.md).  RETV2 puts operand a in the first return
       register (the value) and operand b in the second (the error), then
       returns.  CALL2 and CALLI2 make the call, leave the value in dst as an
       ordinary single def, and store the second return register to local slot
       `slot` (the error).  Keeping the error in a slot rather than a second
       temp means the register allocator still sees one def per call.  Integer
       or pointer value and error only.  Appended after IR_LOC so the existing
       opcode numbers are undisturbed; the KPM1 reader maps by mnemonic, so the
       value is internal. */
    IR_RETV2,
    IR_CALL2, IR_CALLI2,

    /* Threaded-code dispatch (Kobold computed goto, doc/languages/kobold).
       LABADDR materializes the address of a local code label (carried in
       `label`, as IR_JMP does) into `dst` -- the IR_LEA analog for a label.
       IJMP is an indirect jump through the address in operand `a`, a block
       terminator -- the IR_JMP analog through a register.  Appended last so the
       existing opcode numbers are undisturbed; the KPM1 reader maps by
       mnemonic, so the value is internal.

       LABADDR64 / IJMP64 are the 64-bit-pointer twins, for an LP64 front end
       (skj-cc on x86-64 and arm64) where a label address is a full 64-bit
       value: they differ from the 32-bit forms only in the spill/reload width
       of the result and the jump operand, exactly as IR_LEA64 does for IR_LEA.
       An ILP32 front end (skj-kp, and skj-cc on the 32-bit targets) uses the
       plain LABADDR / IJMP. */
    IR_LABADDR, IR_IJMP,
    IR_LABADDR64, IR_IJMP64,
};

/****************************************************************
 * IR data structures
 ****************************************************************/

/* Extended inline asm operand (cc: asm(template : outputs : inputs : clobbers)).
   The template in ir_insn.sym references operand N as %N, outputs numbered
   first, then inputs.  A plain "r"-class operand is materialised in any GP
   register; a name in braces ("{$v0}") pins it to that physical register. */
struct ir_asm_op {
    char *constraint;   /* "=r", "r", "+r", "0", "i", "{$reg}" */
    char *pin_reg;      /* physical register to pin to, or NULL for any GP reg;
                           set from a "{$reg}" constraint or a register-bound
                           local variable (register T x __asm__("$reg")) */
    int temp;           /* input value temp, or output result temp */
    int size;           /* operand width in bytes (the C type size); the 64-bit
                           backends pick a 32- or 64-bit register name by it */
    int is_output;
    int is_inout;       /* "+": read and written (one operand) */
};

struct ir_asm_info {
    int noutputs;
    int ninputs;                /* ops[] holds noutputs outputs then ninputs inputs */
    struct ir_asm_op *ops;
    char **clobbers;
    int nclobbers;
    int is_volatile;
};

struct ir_insn {
    int op;
    int dst;
    int a, b;
    int64_t imm;        /* 64-bit: holds a LIC64 value or an f64's bits, which do
                           not fit a 32-bit long on an ILP32 host (rv32) */
    char *sym;
    struct ir_asm_info *asm_info;  /* IR_ASM only: NULL = basic (verbatim sym) */
    int slot;
    int label;
    int nargs;
    int vararg;         /* on an IR_ARG/IR_ARG64/IR_FARG: this is an unnamed
                           argument of a variadic call.  Only the RISC-V backend
                           reads it (to place unnamed args on the stack); the
                           other backends keep their psABI placement. */
    int argalign;       /* on an IR_ARG: the byte alignment this argument's slot
                           requires in the outgoing argument structure (8 for
                           the first word of a by-value struct with 8-aligned
                           members).  Only the MIPS backend reads it, to start
                           such a struct on an even word; 0 means word alignment. */
    struct ir_insn *next;
};

struct ir_func {
    struct arena *arena;
    char *name;
    char *from_unit;    /* non-null: this definition was absorbed from that unit into a
                           self-contained bundle, so the linker folds it against another
                           copy of the same symbol (identical, or a link error). NULL for a
                           module's own definition, which is unique. */
    const char *src_file; /* source file this function was compiled from, set by a
                             front end under -g for the debug-info line table; NULL
                             when debug info is off.  The per-statement line lives
                             on each IR_LOC marker (its imm). */
    int is_local;
    int nparams;
    int nslots;
    int *slot_size;
    int *slot_align;    /* per-slot natural alignment in bytes, or NULL if the
                           front end did not set it.  A backend that cares about
                           a slot's alignment (the MIPS o32 argument structure,
                           where a doubleword scalar is 8-aligned but a word-
                           sized aggregate is only 4-aligned) reads it here; with
                           NULL or a 0 entry it falls back to inferring 8 from an
                           8-multiple size, which is exact for a scalar-only
                           front end. */
    int *param_class;   /* per-param: 0 = integer/pointer, 1 = float (for the
                           register calling convention); NULL if unset */
    signed char *param_neb; /* psABI: register slots for param i (1 for a
                           scalar; 1-4 for a struct in registers, up to 2 SysV
                           eightbytes or 4 AAPCS64 HFA members; 0 = on the
                           stack).  NULL unless the psABI is in effect */
    signed char *param_cls; /* psABI: 4 entries per param, the class of each
                           slot (0 = INTEGER/gp, 1 = FLOAT/fp); a -2 in slot 0
                           marks a MEMORY struct read from the stack */
    signed char *param_fw; /* psABI: per-param 1 = a single-precision (4-byte)
                           float scalar, 0 otherwise.  The RISC-V ilp32 ABI
                           passes a single float in one integer register and a
                           double in two, a distinction the local slot size
                           loses (a float slot is widened to 8), so the RV
                           backend reads it here; NULL unless set */
    signed char ret_neb; /* psABI: return-struct register slots (0 = scalar/void
                           via the ordinary RETV paths; 1-4 = struct in
                           registers; -1 = MEMORY, returned via a hidden ptr) */
    signed char ret_cls[4]; /* psABI: class of each return slot */
    int is_variadic;    /* function takes `...`; the prologue saves the arg
                           registers for va_arg (SysV register save area) */
    int ntemps;
    int nlabels;
    int nspills;
    int nfspills;
    int ni64spills;
    int *temp_reg;
    int *temp_spill;
    struct ir_insn *head;
    struct ir_insn *tail;
    struct ir_func *next;
};

/*
 * One initializer chunk of an aggregate global's byte image.  Items are held
 * in ascending offset order; a backend pads with zeros between them and to the
 * global's full size.  A chunk is either a scalar of `size` bytes (1/2/4/8,
 * value in `ival`) or, when `sym` is set, a 4-byte reference to that symbol.
 * Keeping it typed (not a raw byte array) lets the assembler apply the target
 * endianness and lets a pointer field carry a relocation.
 */
struct ir_init {
    int offset;         /* byte offset within the global image */
    int size;           /* 1, 2, 4, or 8 */
    int64_t ival;       /* scalar value bits (used when sym is null) */
    char *sym;          /* non-null: a 4-byte reference to this symbol */
    struct ir_init *next;
};

struct ir_global {
    char *name;
    char *from_unit;    /* non-null: absorbed from that unit into a bundle (see ir_func). */
    int base_type;
    int arr_size;
    int align;          /* required byte alignment; 0 = base_type default */
    struct ir_init *inits;  /* non-null: aggregate byte image (see ir_init) */
    int is_ptr;
    int is_local;
    int is_export;      /* a unit's exported var: visible to other modules at link */
    int is_rodata;      /* an immutable global (string literal, real pool, const): read-only */
    int is_strobj;      /* a static string object: the backend emits the {refcount,kind,len,cap}
                           header in target endianness, then init_string as the text + NUL.
                           Keeps the Kobold string descriptor endian-correct on a big-endian
                           target (ColdFire), where a baked little-endian header would be
                           byte-swapped.  base_type stays IR_I8; init_strlen is the text length. */
    int64_t *init_ivals;
    char **init_syms;
    int init_count;
    char *init_string;
    int init_strlen;
    struct ir_global *next;
};

struct ir_program {
    struct ir_func *funcs;
    struct ir_global *globals;
};

/****************************************************************
 * IR builder API
 ****************************************************************/

struct ir_func *ir_new_func(struct arena *a, const char *name);
int ir_new_temp(struct ir_func *fn);
int ir_new_label(struct ir_func *fn);
struct ir_insn *ir_emit(struct ir_func *fn, int op);
struct ir_insn *ir_loc(struct ir_func *fn, int line);  /* IR_LOC marker (-g) */
int ir_op_is_float_def(int op);
int ir_op_is_i64_def(int op);

/* Write each float temp's register storage format into out[0..fn->ntemps): 1 for
   f32 (single) format, 0 for f64.  See the definition for how the two front ends'
   float models are told apart. */
void ir_classify_f32(struct ir_func *fn, unsigned char *out);

/****************************************************************
 * Register allocation
 ****************************************************************/

void regalloc(struct ir_func *fn);

/****************************************************************
 * Back-end interface
 *
 * regalloc() and target_emit() are provided by the linked backend.
 * For compile-time target selection, link a different backend:
 *   ColdFire: backend/regalloc_cf.c + backend/cf_emit.c
 *   RISC-V:   backend/regalloc_rv.c + backend/rv_emit.c  (planned)
 ****************************************************************/

void target_emit(FILE *out, struct ir_program *prog);

/* The overflow-trap policy of an AOT target_emit.  0 (the default) is the hardware
   policy the C compiler wants: a divide relies on the CPU fault and a checked
   arithmetic op, which C never emits, is left to wrap.  A front end whose semantics
   trap on overflow (Kobold) sets this to 1 before target_emit so the checked ops
   call the trap helper instead, matching that language's JIT.  It is a mode, not
   per-call data, so it rides a flag rather than a wider target_emit signature; the
   backends that have a hardware mode (x86-64, arm64) read it, and rv always guards.
   Defined in ir.c so every driver links one copy. */
extern int target_aot_trap_guarded;

#endif /* IR_H */
