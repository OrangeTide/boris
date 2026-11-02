/* kpm.h : reader for the KPM1 text module format */

#ifndef KPM_H
#define KPM_H

#include <stddef.h>
#include <stdint.h>

#include "ir.h"

/* IR_ADDO, IR_SUBO, IR_MULO, and IR_LOC are defined directly in the Skjegg
   ir.h opcode enum, so no layered definitions are needed here. */

/* An imported symbol the host must provide before the module runs. */
enum kp_import_kind {
    KP_IMPORT_FUNC,     /* a host function called directly */
    KP_IMPORT_HELPER,   /* a compiler runtime helper */
    KP_IMPORT_TYPE,     /* a host handle (interface) type and its vtable */
};

/* One method of an imported handle type, in vtable-slot order. */
struct kp_method {
    char *name;
    char **param_cls;   /* ABI class token per declared parameter */
    int nparams;
    char *ret_cls;
};

struct kp_import {
    int kind;
    char *name;
    char **param_cls;   /* func/helper: class token per parameter */
    int nparams;
    char *ret_cls;      /* func/helper: result class */
    struct kp_method *methods;  /* type: one per vtable slot */
    int nmethods;
};

/* A direct unit dependency: the used unit's name and the interface fingerprint the module
   was compiled against, so the linker rejects a consumer built against a stale interface. */
struct kp_dep {
    char *name;
    uint32_t fingerprint;
};

/* What a module is (the .module <kind> header). Absent, a module is an object:
   a compiled unit with unresolved imports, for later linking. */
enum kp_module_kind {
    KP_MOD_OBJECT = 0,      /* the default: a compiled unit, for linking */
    KP_MOD_LIBRARY,         /* a loadable library: resolved exports, may import host */
    KP_MOD_EXECUTABLE,      /* a fully linked image with an entry point, ready to run */
};

/* A parsed module: the IR program plus the import and export tables the
   linker resolves against. The arena owns every allocation here. The public
   kp_module wrapper (kp.h) holds this alongside the module's compiled code. */
struct kpm_module {
    struct arena arena;
    struct ir_program prog;
    struct kp_import *imports;
    int nimports;
    char **exports;
    int nexports;
    int kind;           /* enum kp_module_kind, from .module (default object) */
    char *name;         /* the unit's own name (.module object <name>), or NULL */
    char *entry;        /* the .entry routine of an executable, or NULL */
    char *target;       /* the .target hint, or NULL */
    char *source_file;  /* the .file debug hint (-g), or NULL */
    uint32_t iface_fp;  /* the .interface fingerprint, or 0 without an interface */
    struct kp_dep *deps;    /* direct unit dependencies and their expected fingerprints */
    int ndeps;
};

/** Parse a KPM1 text image into a module.
 *
 * Returns 0 on success. On a format error returns -1 and writes a
 * one-line message into err (line-numbered where possible). The module's
 * arena holds all output; release it with kpm_free. On failure the reader
 * releases its own arena and zeroes the module, so no cleanup is required
 * (a defensive kpm_free is harmless).
 */
int kpm_read(struct kpm_module *m, const char *text, size_t len,
             char *err, size_t errlen);

/* Release everything the module owns. */
void kpm_free(struct kpm_module *m);

/* The mnemonic for an ir_op, e.g. "ADD" (without the IR_ prefix), or NULL. */
const char *kpm_op_name(int op);

#endif /* KPM_H */
