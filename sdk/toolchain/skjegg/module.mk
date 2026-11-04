# Vendored skjegg RV32 toolchain (v0.39.0). These are host tools built with the
# native CC; they run at build time to produce RV32 guest programs for the VM,
# not part of the server. The server itself links the embedded skj-run emulator
# as the `skjrun` library (see the skjrun target below), not these tools.
#
# Re-vendor with sdk/toolchain/update-skjegg.sh (offline: override ORIGIN to a
# local clone). The generated skjegg.mk beside this file is the authoritative
# source-list/flags reference; this hand-written module.mk mirrors it into
# modular-make so the tools build in the boris tree.
#
# Host tools:
#   skj-pc-rv   Compact Pascal front end -> RV32
#   skj-cc-rv   C -> RV32
#   skj-as-rv   RV32 assembler        skj-ld-rv  RV32 linker      skj-ar  archiver
#   skj-kp-rv   KPM1 -> RV32 (lowers the Kobold front end to the in-guest
#               skj-kpc-rv.elf, run under skj-run)
#   skj-run     guest runner CLI (offline testing; the server embeds skjrun)
# The Kobold front end is built from kpcom.pas source (no checked-in seed, v0.43+)
# by the offline sdk/vm step, which builds a host Compact Pascal compiler
# (skj-pc-x86-64) from the vendored pascal/ + x86-64 backend sources for that.

SKJTC_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
# Use -iquote, not -I: for #include "..." these dirs are searched before every
# -I dir, so skjegg's own headers (util.h, ir.h, type.h, ...) win over boris's
# same-named headers that the global PROJECT_CPPFLAGS puts on the -I path.
SKJTC_CPPFLAGS := -iquote$(SKJTC_DIR) -iquote$(SKJTC_DIR)ir -iquote$(SKJTC_DIR)cpp \
                  -iquote$(SKJTC_DIR)cc -iquote$(SKJTC_DIR)backend \
                  -iquote$(SKJTC_DIR)as -iquote$(SKJTC_DIR)ld -iquote$(SKJTC_DIR)dwarf \
                  -iquote$(SKJTC_DIR)kobold -iquote$(SKJTC_DIR)pascal \
                  -iquote$(SKJTC_DIR)emu -iquote$(SKJTC_DIR)fs
# Vendored third-party sources: build quietly rather than police their warnings.
SKJTC_CFLAGS := -std=c99 -O2 -w

# Shared IR core, compiled once and linked into each compiler tool.
LIBRARIES += skjir
skjir_DIR := $(SKJTC_DIR)
skjir_SRCS := ir/ir.c ir/util.c ir/arena.c
skjir_CPPFLAGS := $(SKJTC_CPPFLAGS)
skjir_CFLAGS := $(SKJTC_CFLAGS)

# RV32 code-generation backend, shared by the C, Pascal, and Kobold front ends.
LIBRARIES += skjrv
skjrv_DIR := $(SKJTC_DIR)
skjrv_SRCS := backend/regalloc_rv.c backend/rv_select.c backend/rv_mc_text.c
skjrv_CPPFLAGS := $(SKJTC_CPPFLAGS)
skjrv_CFLAGS := $(SKJTC_CFLAGS)

# Shared linker map-file reader, used by both skj-ld-rv and skj-ar (a source in
# more than one target must live in a single lib: modular-make compiles each
# source exactly once).
LIBRARIES += skjmapfile
skjmapfile_DIR := $(SKJTC_DIR)
skjmapfile_SRCS := ld/mapfile.c
skjmapfile_CPPFLAGS := $(SKJTC_CPPFLAGS)
skjmapfile_CFLAGS := $(SKJTC_CFLAGS)

# skj-pc-rv: the Compact Pascal compiler (RV32 backend). Builds the Kobold
# front end kpcom.pas from source.
EXECUTABLES += skj-pc-rv
skj-pc-rv_DIR := $(SKJTC_DIR)
skj-pc-rv_SRCS := pascal/lex.c pascal/parse.c pascal/lower.c pascal/main.c
skj-pc-rv_CPPFLAGS := $(SKJTC_CPPFLAGS)
skj-pc-rv_CFLAGS := $(SKJTC_CFLAGS)
skj-pc-rv_LIBS := skjrv skjir

# skj-cc-rv: C -> RV32. SKJ_INCLUDE_DIR bakes the default guest-header search
# path (the vendored include/), matching the generated skjegg.mk.
EXECUTABLES += skj-cc-rv
skj-cc-rv_DIR := $(SKJTC_DIR)
skj-cc-rv_SRCS := cc/lex.c cc/parse.c cc/type.c cc/lower.c cc/main.c \
                  cpp/tok.c cpp/macro.c cpp/cond.c cpp/dir.c
skj-cc-rv_CPPFLAGS := $(SKJTC_CPPFLAGS) -DCC_RISCV \
                      -DSKJ_INCLUDE_DIR='"$(abspath $(SKJTC_DIR)include)"'
skj-cc-rv_CFLAGS := $(SKJTC_CFLAGS)
skj-cc-rv_LIBS := skjrv skjir

# skj-as-rv: RV32 assembler. Pulls dwarf/dwarf.c (every assembler emits DWARF
# line tables for -g).
EXECUTABLES += skj-as-rv
skj-as-rv_DIR := $(SKJTC_DIR)
skj-as-rv_SRCS := as/rv_main.c as/asm_lex.c as/asm_obj.c as/rv_parse.c \
                  as/rv_encode.c as/rv_macro.c as/rv_elf.c dwarf/dwarf.c
skj-as-rv_CPPFLAGS := $(SKJTC_CPPFLAGS)
skj-as-rv_CFLAGS := $(SKJTC_CFLAGS)
skj-as-rv_LIBS := skjir

# skj-ld-rv: RV32 static linker.
EXECUTABLES += skj-ld-rv
skj-ld-rv_DIR := $(SKJTC_DIR)
skj-ld-rv_SRCS := ld/rv_main.c ld/rv_elf_read.c ld/rv_link.c ld/rv_elf_write.c \
                  ld/rv_archive.c ld/link.c ld/script.c
skj-ld-rv_CPPFLAGS := $(SKJTC_CPPFLAGS)
skj-ld-rv_CFLAGS := $(SKJTC_CFLAGS)
skj-ld-rv_LIBS := skjmapfile skjir

# skj-ar: target-neutral archive tool.
EXECUTABLES += skj-ar
skj-ar_DIR := $(SKJTC_DIR)
skj-ar_SRCS := ar/main.c
skj-ar_CPPFLAGS := $(SKJTC_CPPFLAGS)
skj-ar_CFLAGS := $(SKJTC_CFLAGS)
skj-ar_LIBS := skjmapfile skjir

# skj-kp-rv: KPM1 -> RV32 AOT compiler.
EXECUTABLES += skj-kp-rv
skj-kp-rv_DIR := $(SKJTC_DIR)
skj-kp-rv_SRCS := kobold/aot_main.c kobold/kpm.c
skj-kp-rv_CPPFLAGS := $(SKJTC_CPPFLAGS) -DKP_AOT_RV
skj-kp-rv_CFLAGS := $(SKJTC_CFLAGS)
skj-kp-rv_LIBS := skjrv skjir

# skjrun: the embedded emulator the SERVER links (not a host tool). The RV32
# CPU, the ELF32/64 loaders, the host platform shim, the guest syscall service,
# and v0.36's embeddable scheduler (emu/sched.c: sched_init / sched_add_root /
# sched_step / sched_waits / sched_mark_ready / sched_wake_deadlines /
# sched_destroy) with its RV32 binding (emu/rv_user.c) and the proc: pseudo-fs
# emu/guest.c serves from the process table (emu/procfs.c, added in v0.42). The
# boris runtime adapter drives this scheduler from the iox reactor. Deliberately
# excludes emu/main.c
# (the CLI) and fs/p9_server.c: boris's CAS-backed 9P server (src/vfs/p9_vfs.c)
# provides the p9_server_* symbols emu/guest.c's doorbell calls, so they are left
# unresolved in this archive and satisfied by boris at the final link.
EMU_GATES := -DEMU_COLDFIRE=0 -DEMU_RV32=1 -DEMU_MIPS32=0 -DEMU_HV=0
LIBRARIES += skjrun
skjrun_DIR := $(SKJTC_DIR)
skjrun_SRCS := emu/guest.c emu/hostplat.c emu/elf32.c emu/elf64.c emu/rv32.c \
               emu/sched.c emu/rv_user.c emu/procfs.c
skjrun_CPPFLAGS := $(SKJTC_CPPFLAGS) $(EMU_GATES)
skjrun_CFLAGS := $(SKJTC_CFLAGS)
# emu/guest.c references the fs/p9_server.h entry points; boris provides them
# (the p9stub lib, later the CAS-backed server in src/vfs). Declaring the
# dependency makes the modular-make topological order place the provider after
# skjrun on the link line, which a static link requires.
skjrun_LIBS := vfs
# Dependents (the boris server) include the emu/fs headers (angle includes:
# <guest.h>, <rv32.h>, <elf32.h>, <sched.h>, <p9_server.h>) and link libm.
skjrun_EXPORTED_CPPFLAGS := -I$(SKJTC_DIR)emu -I$(SKJTC_DIR)fs
skjrun_EXPORTED_LDLIBS := -lm

# skj-run: the guest runner CLI, for offline testing. Built on the skjrun
# library plus the CLI driver. It does NOT link the vendored fs/p9_server.c:
# skjrun already pulls the boris p9 provider (p9stub, later the CAS-backed
# server) through its dependency, and linking the vendored server too would
# doubly define p9_server_*. In the boris build the CLI's --9p is therefore a
# stub (--mount hostcap still works); use the upstream skjegg build for full
# 9p-server testing. The server embeds skjrun with its own p9 server instead.
EXECUTABLES += skj-run
skj-run_DIR := $(SKJTC_DIR)
skj-run_SRCS := emu/main.c
skj-run_CPPFLAGS := $(SKJTC_CPPFLAGS) $(EMU_GATES)
skj-run_CFLAGS := $(SKJTC_CFLAGS)
skj-run_LIBS := skjrun
skj-run_LDLIBS := -lm
