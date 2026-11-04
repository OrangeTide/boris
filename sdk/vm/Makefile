# Build the VM guest programs with the vendored skjegg RV32 toolchain.
#
# The tools are host executables built by the main boris build. Point BIN at
# them and run this after that build:
#
#   make -C sdk/vm BIN=$(pwd)/_out/<os>-<arch>/bin
#
# Output ELFs go to DEST (data/vm by default), where the runtime's image path
# looks for program images. This is a separate step, not part of the main
# build, because the tools run on the host: a cross-compiled boris build
# produces cross tools that cannot run here.
#
# Two guest flavors are built:
#
#   * libc guests  -- the unix userland (jsh + coreutils) and plain C programs.
#     They link skjegg's freestanding crt and its fs-interpose libc, reach the
#     host through the raw Linux syscall seam, and reach files through the fs/
#     mount table (a boris 9P mount, a hostcap directory). This is what @run and
#     @compile load.
#
#   * band guests  -- command verbs and resident agents. They link boris's own
#     entry shims and the host-call stubs, reaching boris's services (object and
#     world access, the mailbox) through the 0x00100000 selector band. They do
#     not use libc.

SKJ  := ../toolchain/skjegg
BIN  ?= ../../_out/x86_64-linux-gnu/bin
DEST ?= ../../data/vm
B    := build

# Where the `toolchain` target installs the RV32 toolchain guests and the link
# inputs @compile stages into a build directory (see the toolchain section).
TC_DEST := $(DEST)/toolchain
TC_LIB  := $(DEST)/lib

SKJCC := $(BIN)/skj-cc-rv
SKJAS := $(BIN)/skj-as-rv
SKJLD := $(BIN)/skj-ld-rv
SKJAR := $(BIN)/skj-ar

# The host cross toolchain assembles the crt and compiles the two ILP32 helper
# objects (varargs, 64-bit soft divide) that skjegg's own build uses.
RV_AS ?= riscv64-linux-gnu-as
RV_CC ?= riscv64-linux-gnu-gcc

# ---------------------------------------------------------------------------
# The confined libc the libc guests link. The source list mirrors the generated
# sdk/toolchain/skjegg/skjegg.mk, built here into the boris tree so @run and
# @compile have a libc without a skjegg build. FS_WITH_9P is on: a boris guest
# reaches the in-world CAS tree through a 9P mount, not only a hostcap host
# directory.
#
# The flags match skjegg's own full "free" guest libc (its Makefile FS_FREE_CC),
# NOT the generated skjegg.mk LIBC_FSFLAGS: that generated list omits
# FS_WITH_STREAMS and FS_WITH_RAM, which every real skjegg build adds. Without
# FS_WITH_STREAMS the fs-interpose libc never binds fd 0/1/2, so fs_write(1,...)
# drops the write and a guest produces no output. FS_AMBIENT_DEFAULT only takes
# effect when the launcher installs no mount, so it is inert under boris (which
# always writes a mount table) and gives skj-run a host cwd for offline testing.
# ---------------------------------------------------------------------------
# time is in the list though the generated skjegg.mk omits it (another gap in
# that generated list): the RV32 toolchain guests call time().
LIBC_SRCS := string ctype stdlib printf numfmt stdio_core stdio assert malloc \
             sbrk errno strerror rand strtod scanf coro threads stat fileops \
             dirent getenv fdio time
RT_SRCS   := rng
FS_SRCS   := fs ramfs ambientfs hostcap devfs romfs ninefs p9_guest
LIBC_FSFLAGS := -DSKJ_FS_INTERPOSE -DFS_WITH_AMBIENT -DFS_WITH_HOSTCAP \
                -DFS_AMBIENT_DEFAULT -DFS_WITH_DEV -DFS_WITH_ROM -DFS_WITH_9P \
                -DFS_WITH_STREAMS -DFS_WITH_RAM -I$(SKJ)/fs
LIBC_CFLAGS  := -DSKJ_LIBC_FLOAT $(LIBC_FSFLAGS) -I$(SKJ)/include -I$(SKJ)/libc

LIBC_OBJS := $(addprefix $(B)/obj/,$(addsuffix .o,$(LIBC_SRCS) $(RT_SRCS) $(FS_SRCS)))

# The libc link inputs, in the order skjcc uses: the crt first, then the two
# helper objects, the program, the libc archive, and the finalizer last.
LIBC_CRT  := $(B)/crt0.o $(B)/va_rv.o $(B)/soft64_div.o
LIBC_FINI := $(B)/fini.o
LIBC_A    := $(B)/libc.a

# The coreutils served under bin: so jsh resolves a bare command to bin:<name>.
# Their sources live in examples/coreutils/ (not examples/bin/: a global ignore
# pattern "bin/" would hide the sources); the built guests still install to
# DEST/bin, the runtime's bin: mount.
COREUTILS := cat cp echo ls mv rm sleep

.PHONY: all libc userland verbs toolchain clean
all: verbs userland

# ---------------------------------------------------------------------------
# The libc SDK
# ---------------------------------------------------------------------------
libc: $(LIBC_A) $(LIBC_CRT) $(LIBC_FINI)

$(B) $(B)/obj $(B)/bin $(DEST) $(DEST)/bin $(TC_DEST) $(TC_LIB):
	mkdir -p $@

# The crt: start_rv.S pulls in crt_entry_rv.S, syscall_rv.S and i64_rv.S.
$(B)/crt0.o: $(SKJ)/runtime/start_rv.S | $(B)
	$(RV_AS) -I$(SKJ) -I$(SKJ)/runtime -march=rv32im -mabi=ilp32 -o $@ $<

$(B)/va_rv.o: $(SKJ)/runtime/va_rv.c | $(B)
	$(RV_CC) -std=c99 -O2 -Wall -ffreestanding -march=rv32imfd -mabi=ilp32 -c -o $@ $<

$(B)/soft64_div.o: $(SKJ)/runtime/soft64.c | $(B)
	$(RV_CC) -std=c99 -O2 -Wall -ffreestanding -march=rv32imfd -mabi=ilp32 -DSOFT64_NO_MULSHIFT -c -o $@ $<

$(B)/co_switch.o: $(SKJ)/runtime/co_switch_rv.S | $(B)
	$(SKJAS) -o $@ $<

# setjmp/longjmp for guests that use it (jsh, lua). The RV32 source is in the
# vendored runtime; it is assembled into libc.a so ar(1) dead-strip pulls it
# only for a guest that references setjmp. (vendor.sh --with runtime omits the
# setjmp_*.S files in v0.39.0; setjmp_rv.S was copied in by hand pending a
# vendor.sh fix, so a re-vendor must restore it.)
$(B)/setjmp.o: $(SKJ)/runtime/setjmp_rv.S | $(B)
	$(SKJAS) -o $@ $<

$(B)/fini.o: $(SKJ)/libc/fini.c | $(B)
	$(SKJCC) -I$(SKJ)/include -o $(B)/fini.s $<
	$(SKJAS) -o $@ $(B)/fini.s

$(B)/obj/%.o: $(SKJ)/libc/%.c | $(B)/obj
	$(SKJCC) $(LIBC_CFLAGS) -o $(B)/obj/$*.s $<
	$(SKJAS) -o $@ $(B)/obj/$*.s

$(B)/obj/%.o: $(SKJ)/runtime/%.c | $(B)/obj
	$(SKJCC) $(LIBC_CFLAGS) -o $(B)/obj/$*.s $<
	$(SKJAS) -o $@ $(B)/obj/$*.s

$(B)/obj/%.o: $(SKJ)/fs/%.c | $(B)/obj
	$(SKJCC) $(LIBC_CFLAGS) -o $(B)/obj/$*.s $<
	$(SKJAS) -o $@ $(B)/obj/$*.s

$(LIBC_A): $(LIBC_OBJS) $(B)/co_switch.o $(B)/setjmp.o
	$(SKJAR) rcs $@ $^

# Link one libc guest from a single C source plus the shared libc archive.
#   $(1) source .c    $(2) output .elf    $(3) extra cflags
define libc_guest
$(2): $(1) $$(LIBC_CRT) $$(LIBC_A) $$(LIBC_FINI) | $$(patsubst %/,%,$$(dir $(2)))
	$$(SKJCC) $$(LIBC_CFLAGS) $(3) -o $$(B)/$$(notdir $(1:.c=.s)) $(1)
	$$(SKJAS) -o $$(B)/$$(notdir $(1:.c=.o)) $$(B)/$$(notdir $(1:.c=.s))
	$$(SKJLD) -o $$@ $$(LIBC_CRT) $$(B)/$$(notdir $(1:.c=.o)) $$(LIBC_A) $$(LIBC_FINI)
endef

# ---------------------------------------------------------------------------
# The unix userland: jsh and the coreutils, under DEST/bin for bin: mounts.
# ---------------------------------------------------------------------------
userland: $(DEST)/jsh.elf $(foreach t,$(COREUTILS),$(DEST)/bin/$(t))

$(eval $(call libc_guest,examples/jsh.c,$(DEST)/jsh.elf,-DSKJEGG))
$(foreach t,$(COREUTILS),$(eval $(call libc_guest,examples/coreutils/$(t).c,$(DEST)/bin/$(t),)))

# ---------------------------------------------------------------------------
# The RV32 toolchain as guests: skj-cc-rv / skj-as-rv / skj-ld-rv, built from
# the vendored skjegg toolchain sources, compiled by the host skj-cc-rv to RV32
# and linked against the confined libc. @compile runs these stages under the
# embedded runtime over a hostcap build directory, so compiling a guest in world
# needs no host execve and stays inside the security sandbox. cpp is folded into
# skj-cc-rv (no separate preprocessor stage); there is no in-guest archiver.
#
# Built on demand, NOT part of `all`: the ELFs are large and only @compile needs
# them. Run `make -C sdk/vm toolchain` after the main build. The stages install
# to DEST/toolchain; the link inputs a C or assembly program needs (the crt, the
# varargs and soft-divide helpers, the libc archive, the finalizer) install to
# DEST/lib, which @compile stages into each build directory.
# ---------------------------------------------------------------------------
TC_CC_SRCS := cc/lex.c cc/parse.c cc/type.c cc/lower.c cc/main.c \
              cpp/tok.c cpp/macro.c cpp/cond.c cpp/dir.c \
              ir/ir.c ir/util.c ir/arena.c \
              backend/regalloc_rv.c backend/rv_select.c backend/rv_mc_text.c
TC_AS_SRCS := as/rv_main.c as/asm_lex.c as/asm_obj.c as/rv_parse.c \
              as/rv_encode.c as/rv_macro.c as/rv_elf.c dwarf/dwarf.c \
              ir/util.c ir/arena.c
TC_LD_SRCS := ld/rv_main.c ld/rv_elf_read.c ld/rv_link.c ld/rv_elf_write.c \
              ld/rv_archive.c ld/link.c ld/script.c ld/mapfile.c \
              ir/util.c ir/arena.c

TC_CC_INC := -I$(SKJ) -I$(SKJ)/cc -I$(SKJ)/cpp -I$(SKJ)/ir -I$(SKJ)/backend
TC_AS_INC := -I$(SKJ) -I$(SKJ)/as -I$(SKJ)/ir -I$(SKJ)/dwarf
TC_LD_INC := -I$(SKJ) -I$(SKJ)/ld -I$(SKJ)/ir

# The per-stage objects, under a per-stage tree so as/ and ld/ (both carry an
# rv_main.c) do not collide.
TC_CC_OBJS := $(addprefix $(B)/tc/cc/,$(TC_CC_SRCS:.c=.o))
TC_AS_OBJS := $(addprefix $(B)/tc/as/,$(TC_AS_SRCS:.c=.o))
TC_LD_OBJS := $(addprefix $(B)/tc/ld/,$(TC_LD_SRCS:.c=.o))

# The link inputs @compile stages per build, installed under DEST/lib: the five
# a C or assembly program links, plus the two a Kobold program links (its crt
# and the freestanding runtime archive).
TC_LIB_FILES := $(TC_LIB)/crt0.o $(TC_LIB)/va_rv.o $(TC_LIB)/soft64_div.o \
                $(TC_LIB)/libc.a $(TC_LIB)/fini.o \
                $(TC_LIB)/kp_crt_rv.o $(TC_LIB)/libkpaot-rv-free.a

toolchain: $(TC_DEST)/skj-cc-rv.elf $(TC_DEST)/skj-as-rv.elf \
           $(TC_DEST)/skj-ld-rv.elf $(TC_DEST)/skj-kp-rv.elf \
           $(TC_DEST)/skj-kpc-rv.elf $(TC_LIB_FILES)

$(TC_LIB)/%: $(B)/% | $(TC_LIB)
	cp $< $@

# Build one toolchain stage ELF. The sources mirror the skjegg layout under a
# per-stage object tree. $(4) carries the per-stage defines (-DCC_RISCV for the
# C/assembler/linker stages, the KPM1 AOT defines for the Kobold backend).
#   $(1) stage name   $(2) include flags   $(3) object list   $(4) defines
define tool_guest
$(B)/tc/$(1)/%.o: $(SKJ)/%.c
	@mkdir -p $$(dir $$@)
	$$(SKJCC) $(4) $(2) -o $$(@:.o=.s) $$<
	$$(SKJAS) -o $$@ $$(@:.o=.s)
$(TC_DEST)/skj-$(1)-rv.elf: $(3) $$(LIBC_CRT) $$(LIBC_A) $$(LIBC_FINI) | $$(TC_DEST)
	$$(SKJLD) -o $$@ $$(LIBC_CRT) $(3) $$(LIBC_A) $$(LIBC_FINI)
endef

$(eval $(call tool_guest,cc,$(TC_CC_INC),$(TC_CC_OBJS),-DCC_RISCV))
$(eval $(call tool_guest,as,$(TC_AS_INC),$(TC_AS_OBJS),-DCC_RISCV))
$(eval $(call tool_guest,ld,$(TC_LD_INC),$(TC_LD_OBJS),-DCC_RISCV))

# The Kobold backend skj-kp-rv.elf: KPM1 -> RV32 asm. Same C libc as the other
# stages, so it reuses tool_guest with the KPM1 AOT defines (SKJ_KPM_ARCH names
# the target the emitted modules must match).
TC_KP_SRCS := kobold/aot_main.c kobold/kpm.c \
              ir/ir.c ir/util.c ir/arena.c \
              backend/regalloc_rv.c backend/rv_select.c backend/rv_mc_text.c
TC_KP_INC  := -I$(SKJ) -I$(SKJ)/ir -I$(SKJ)/backend -I$(SKJ)/kobold
TC_KP_OBJS := $(addprefix $(B)/tc/kp/,$(TC_KP_SRCS:.c=.o))
TC_KP_DEFS := -DKP_AOT_RV -DSKJ_KPM_ARCH='"rv32"'
$(eval $(call tool_guest,kp,$(TC_KP_INC),$(TC_KP_OBJS),$(TC_KP_DEFS)))

# ---------------------------------------------------------------------------
# The Kobold-Pascal runtime and front end.
#
# The Kobold pipeline is four stages: the front end skj-kpc-rv.elf lowers .pas
# to a KPM1 module, the backend skj-kp-rv.elf (above) compiles that to RV32 asm,
# then the shared skj-as-rv / skj-ld-rv assemble and link it against the Kobold
# freestanding runtime archive (libkpaot-rv-free.a) and its crt (kp_crt_rv.o).
# @compile runs all four as guests, so compiling Kobold in world needs no host
# execve.
#
# The front end is itself a Kobold program, built from source with no checked-in
# seed (skjegg v0.43+). A host Compact Pascal compiler (skj-pc-x86-64, built
# here) compiles the Kobold front end kpcom.pas into a host binary skj-kpc-rv
# that emits rv32 KPM1; running it on kpcom.pas yields kpcom-rv.kpm at build
# time, which the host skj-kp-rv backend lowers to RV32 asm, assembled and
# linked against the Kobold runtime into the guest skj-kpc-rv.elf.
#
# The runtime flag groups mirror skjegg's own freestanding build. The archive
# carries its own minimal libc subset (sbrk/numfmt/strtod/ctype/stat/fileops)
# and the fs/ layer, so a Kobold guest links only the crt, its object, and this
# archive, not the C libc.
# ---------------------------------------------------------------------------
SKJKP := $(BIN)/skj-kp-rv

# The seedless front-end build (v0.43+) runs host-native x86-64 tools built here
# from the vendored Pascal front end and x86-64 backend. HOST_CC is the native
# compiler; X64_ASM assembles the GNU intel-syntax output the x86-64 backend
# emits (default: the host `as --64`).
HOST_CC  ?= cc
X64_ASM  ?= as
KP_FE_PASCAL := pascal/lex.c pascal/parse.c pascal/lower.c pascal/main.c
KP_FE_IR     := ir/ir.c ir/util.c ir/arena.c
KP_FE_BE_X64 := backend/regalloc_x86.c backend/x86_select.c backend/mc_text.c \
                backend/x86_aot.c
KP_FE_SRCS   := $(addprefix $(SKJ)/,$(KP_FE_PASCAL) $(KP_FE_IR) $(KP_FE_BE_X64))

KP_SKJF   := -DKP_FREESTANDING -DKP_REAL=double -I$(SKJ)/kobold -I$(SKJ)/ir
KP_FSF    := -DSKJ_FS_INTERPOSE -DFS_WITH_AMBIENT -DFS_WITH_HOSTCAP -I$(SKJ)/fs
KP_LIBCF  := -I$(SKJ)/include -I$(SKJ)/libc
KP_FSFREE := -I$(SKJ)/include -I$(SKJ)/libc -I$(SKJ)/fs -DFS_WITH_AMBIENT \
             -DFS_WITH_HOSTCAP -DFS_AMBIENT_DEFAULT -DFS_WITH_DEV -DFS_WITH_ROM \
             -DFS_WITH_9P -DFS_WITH_STREAMS -DFS_WITH_RAM

# Archive members, grouped by source dir and flag set (the subdir keeps the
# per-group flags unambiguous for the pattern rules below).
KP_A_OBJS := \
  $(B)/kp/kob/rt_free.o $(B)/kp/kob/kp_io.o $(B)/kp/kob/co_free.o \
  $(B)/kp/kob/math_free.o $(B)/kp/kob/str_core.o $(B)/kp/kob/dynarr.o \
  $(B)/kp/kob/map.o \
  $(B)/kp/kobfs/io_free.o \
  $(B)/kp/rt/rng.o $(B)/kp/rt/rng_glue.o $(B)/kp/rt/sched_glue.o \
  $(B)/kp/rt64/soft64.o \
  $(B)/kp/libc/sbrk.o $(B)/kp/libc/numfmt.o $(B)/kp/libc/strtod.o \
  $(B)/kp/libc/ctype.o \
  $(B)/kp/libcfs/stat.o $(B)/kp/libcfs/fileops.o \
  $(B)/kp/fs/fs.o $(B)/kp/fs/ramfs.o $(B)/kp/fs/ambientfs.o $(B)/kp/fs/hostcap.o \
  $(B)/kp/fs/devfs.o $(B)/kp/fs/romfs.o $(B)/kp/fs/ninefs.o $(B)/kp/fs/p9_guest.o \
  $(B)/kp/rv_i64_aot_alias.o $(B)/kp/rv_jit_i64.o $(B)/kp/co_switch_rv.o \
  $(B)/kp/io_free_rv.o

# One cc->as rule per flag group.
$(B)/kp/kob/%.o: $(SKJ)/kobold/%.c
	@mkdir -p $(dir $@)
	$(SKJCC) $(KP_SKJF) -o $(@:.o=.s) $<
	$(SKJAS) -o $@ $(@:.o=.s)
$(B)/kp/kobfs/%.o: $(SKJ)/kobold/%.c
	@mkdir -p $(dir $@)
	$(SKJCC) $(KP_SKJF) $(KP_LIBCF) $(KP_FSF) -o $(@:.o=.s) $<
	$(SKJAS) -o $@ $(@:.o=.s)
$(B)/kp/rt/%.o: $(SKJ)/runtime/%.c
	@mkdir -p $(dir $@)
	$(SKJCC) $(KP_SKJF) -o $(@:.o=.s) $<
	$(SKJAS) -o $@ $(@:.o=.s)
$(B)/kp/rt64/%.o: $(SKJ)/runtime/%.c
	@mkdir -p $(dir $@)
	$(SKJCC) $(KP_SKJF) -DSOFT64_NO_MULSHIFT -o $(@:.o=.s) $<
	$(SKJAS) -o $@ $(@:.o=.s)
$(B)/kp/libc/%.o: $(SKJ)/libc/%.c
	@mkdir -p $(dir $@)
	$(SKJCC) $(KP_LIBCF) -o $(@:.o=.s) $<
	$(SKJAS) -o $@ $(@:.o=.s)
$(B)/kp/libcfs/%.o: $(SKJ)/libc/%.c
	@mkdir -p $(dir $@)
	$(SKJCC) $(KP_LIBCF) $(KP_FSF) -o $(@:.o=.s) $<
	$(SKJAS) -o $@ $(@:.o=.s)
$(B)/kp/fs/%.o: $(SKJ)/fs/%.c
	@mkdir -p $(dir $@)
	$(SKJCC) $(KP_FSFREE) -o $(@:.o=.s) $<
	$(SKJAS) -o $@ $(@:.o=.s)

# Assembly members. rv_jit_i64.S does `.include "runtime/i64_rv.S"`, a path
# relative to the skjegg root, so it is assembled with that root as the working
# directory; the others resolve their includes beside themselves.
$(B)/kp/rv_i64_aot_alias.o: $(SKJ)/kobold/rv_i64_aot_alias.S
	@mkdir -p $(dir $@)
	$(SKJAS) -o $@ $<
$(B)/kp/co_switch_rv.o: $(SKJ)/runtime/co_switch_rv.S
	@mkdir -p $(dir $@)
	$(SKJAS) -o $@ $<
$(B)/kp/io_free_rv.o: $(SKJ)/runtime/io_free_rv.S
	@mkdir -p $(dir $@)
	$(SKJAS) -o $@ $<
$(B)/kp/rv_jit_i64.o: $(SKJ)/jit/rv_jit_i64.S $(SKJ)/runtime/i64_rv.S
	@mkdir -p $(dir $@)
	cd $(SKJ) && $(abspath $(SKJAS)) -o $(abspath $@) jit/rv_jit_i64.S

# The crt shares runtime/crt_entry_rv.S with the C crt (kp_crt_rv.S includes it
# relative to its own dir).
$(B)/kp_crt_rv.o: $(SKJ)/kobold/kp_crt_rv.S | $(B)
	$(SKJAS) -o $@ $<

$(B)/libkpaot-rv-free.a: $(KP_A_OBJS)
	$(SKJAR) rcs $@ $(KP_A_OBJS)

# The front end, built from source (no seed). skj-pc-x86-64 is the host Compact
# Pascal compiler; it compiles kpcom.pas (with KP_TARGET_RV baked in) into the
# host binary skj-kpc-rv, which emits rv32 KPM1.
$(B)/skj-pc-x86-64: $(KP_FE_SRCS) | $(B)
	$(HOST_CC) -std=c99 -O2 -w -DX86_BITS=64 -DSKJ_LP64=1 \
	    -I$(SKJ) -I$(SKJ)/pascal -I$(SKJ)/ir -I$(SKJ)/backend -o $@ $(KP_FE_SRCS)

$(B)/pascal_rt_host.o: $(SKJ)/runtime/pascal_rt.c | $(B)
	$(HOST_CC) -std=c99 -O2 -DPAS_HOST -c -o $@ $<

$(B)/skj-kpc-rv: $(B)/skj-pc-x86-64 $(SKJ)/tests/pascal_kpcom_host.c $(B)/pascal_rt_host.o $(SKJ)/kobold/kpcom.pas | $(B)
	$(B)/skj-pc-x86-64 -d KOBOLD -d KP_TARGET_RV -o $(B)/kpcom-rv-fe.s $(SKJ)/kobold/kpcom.pas
	$(X64_ASM) --64 $(B)/kpcom-rv-fe.s -o $(B)/kpcom-rv-fe.o
	$(HOST_CC) -no-pie $(B)/kpcom-rv-fe.o $(SKJ)/tests/pascal_kpcom_host.c $(B)/pascal_rt_host.o -lm -o $@

# The rv32 KPM1 of kpcom, regenerated at build time (replaces the old seed).
$(B)/kpcom-rv.kpm: $(B)/skj-kpc-rv $(SKJ)/kobold/kpcom.pas
	$(B)/skj-kpc-rv --emit-kpm $(SKJ)/kobold/kpcom.pas > $@

# The host backend lowers the KPM1 to asm, assembled and linked against the
# Kobold runtime into the guest front end.
$(B)/kpcom-free-rv.s: $(B)/kpcom-rv.kpm | $(B)
	$(SKJKP) $< -o $@
$(B)/kpcom-free-rv.o: $(B)/kpcom-free-rv.s
	$(SKJAS) -o $@ $<
$(TC_DEST)/skj-kpc-rv.elf: $(B)/kp_crt_rv.o $(B)/kpcom-free-rv.o $(B)/libkpaot-rv-free.a | $(TC_DEST)
	$(SKJLD) -o $@ $(B)/kp_crt_rv.o $(B)/kpcom-free-rv.o $(B)/libkpaot-rv-free.a

# ---------------------------------------------------------------------------
# Band guests: the command verbs and resident agents. They link boris's entry
# shims and host-call stubs, not libc, and use the freestanding layout script.
# ---------------------------------------------------------------------------
verbs: $(DEST)/hello.elf $(DEST)/agent.elf $(DEST)/look.elf

BAND_RT := $(B)/crt0-band.o $(B)/stubs.o

$(B)/crt0-band.o: crt0.S | $(B)
	$(SKJAS) -o $@ $<

$(B)/stubs.o: stubs.S | $(B)
	$(SKJAS) -o $@ $<

$(B)/cmd_crt.o: cmd_crt.S | $(B)
	$(SKJAS) -o $@ $<

$(B)/cmd_rt.o: cmd_rt.c include/vmsys.h include/cmd.h | $(B)
	$(SKJCC) -Iinclude -o $(B)/cmd_rt.s cmd_rt.c
	$(SKJAS) -o $@ $(B)/cmd_rt.s

$(B)/verb_rt.o: verb_rt.c include/vmsys.h include/verb.h | $(B)
	$(SKJCC) -Iinclude -o $(B)/verb_rt.s verb_rt.c
	$(SKJAS) -o $@ $(B)/verb_rt.s

$(B)/hello.o: examples/hello.c include/vmsys.h | $(B)
	$(SKJCC) -Iinclude -o $(B)/hello.s examples/hello.c
	$(SKJAS) -o $@ $(B)/hello.s

$(B)/agent.o: examples/agent.c include/vmsys.h include/verb.h | $(B)
	$(SKJCC) -Iinclude -o $(B)/agent.s examples/agent.c
	$(SKJAS) -o $@ $(B)/agent.s

$(B)/look.o: examples/look.c include/vmsys.h include/cmd.h | $(B)
	$(SKJCC) -Iinclude -o $(B)/look.s examples/look.c
	$(SKJAS) -o $@ $(B)/look.s

# A one-shot program supplies main(); an agent links verb_rt.o, which supplies
# main() and calls the program's verb_event.
$(DEST)/hello.elf: $(BAND_RT) $(B)/hello.o | $(DEST)
	$(SKJLD) -T vm.ld -o $@ $(B)/crt0-band.o $(B)/hello.o $(B)/stubs.o

$(DEST)/agent.elf: $(BAND_RT) $(B)/verb_rt.o $(B)/agent.o | $(DEST)
	$(SKJLD) -T vm.ld -o $@ $(B)/crt0-band.o $(B)/agent.o $(B)/verb_rt.o $(B)/stubs.o

# A command verb links cmd_crt.o (typed-slot entry) and cmd_rt.o (the argument
# accessors) in place of the plain crt, and supplies main().
$(DEST)/look.elf: $(B)/stubs.o $(B)/cmd_crt.o $(B)/cmd_rt.o $(B)/look.o | $(DEST)
	$(SKJLD) -T vm.ld -o $@ $(B)/cmd_crt.o $(B)/look.o $(B)/cmd_rt.o $(B)/stubs.o

clean:
	rm -rf $(B)
