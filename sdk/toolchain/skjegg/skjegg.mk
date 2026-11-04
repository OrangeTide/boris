# skjegg.mk — vendored skjegg compiler toolkit
# Origin: https://github.com/OrangeTide/skjegg-compiler-suite.git (49a60c3)
# Components: riscv cc kp pascal as-rv ld-rv ar emu-rv sandbox
# Generated: 2026-11-04
#
# Include from your Makefile:
#   include sdk/toolchain/skjegg/skjegg.mk
#
# Then build with:
#   make skjegg

SKJEGG := $(dir $(lastword $(MAKEFILE_LIST)))
BUILD  ?= build

CC     ?= cc
CFLAGS ?= -std=c99 -O2 -Wall -Wextra -Wpedantic -Wno-unused-parameter
CFLAGS += -I$(BUILD)

# The vendored skjegg version.  Fixed at vendoring time; deliberately not
# derived from git, since git here is your project, not skjegg.
#
# SKJ_VERSION names the release.  The commit is baked in beside it because
# a vendored tree may come from a ref that has moved past that release, and
# a bare release number would then overstate what you actually have.
include $(SKJEGG)version.mk
SKJ_VENDOR_REF    := v0.43.0
SKJ_VENDOR_COMMIT := 49a60c3
SKJ_FULL_VERSION  := $(SKJ_VERSION)$(if $(SKJ_VENDOR_COMMIT),+g$(SKJ_VENDOR_COMMIT))

RV_AS ?= riscv64-linux-gnu-as
RV_LD ?= riscv64-linux-gnu-ld
RV_CC ?= riscv64-linux-gnu-gcc

# sources
SKJ_IR := $(SKJEGG)ir/ir.c $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c
SKJ_RV := $(SKJEGG)backend/regalloc_rv.c $(SKJEGG)backend/rv_select.c $(SKJEGG)backend/rv_mc_text.c
SKJ_PASCAL := $(SKJEGG)pascal/lex.c $(SKJEGG)pascal/parse.c \
              $(SKJEGG)pascal/lower.c $(SKJEGG)pascal/main.c
SKJ_CC := $(SKJEGG)cc/lex.c $(SKJEGG)cc/parse.c $(SKJEGG)cc/type.c \
          $(SKJEGG)cc/lower.c $(SKJEGG)cc/main.c
SKJ_CPP_LIB := $(SKJEGG)cpp/tok.c $(SKJEGG)cpp/macro.c \
               $(SKJEGG)cpp/cond.c $(SKJEGG)cpp/dir.c
SKJ_AS_RV_LIB := $(SKJEGG)as/asm_lex.c $(SKJEGG)as/asm_obj.c \
                 $(SKJEGG)as/rv_parse.c $(SKJEGG)as/rv_encode.c \
                 $(SKJEGG)as/rv_macro.c $(SKJEGG)as/rv_elf.c \
                 $(SKJEGG)dwarf/dwarf.c
SKJ_LD_RV_LIB := $(SKJEGG)ld/rv_elf_read.c $(SKJEGG)ld/rv_link.c \
                 $(SKJEGG)ld/rv_elf_write.c $(SKJEGG)ld/rv_archive.c \
                 $(SKJEGG)ld/link.c $(SKJEGG)ld/script.c $(SKJEGG)ld/mapfile.c

SKJ_ALL :=

SKJ_ALL += $(BUILD)/skj-pc-rv
$(BUILD)/skj-pc-rv: $(SKJ_IR) $(SKJ_RV) $(SKJ_PASCAL) | $(BUILD)
	$(CC) $(CFLAGS) -I$(SKJEGG)pascal -I$(SKJEGG)ir -o $@ $(SKJ_IR) $(SKJ_RV) $(SKJ_PASCAL)

SKJ_ALL += $(BUILD)/skj-cc-rv
$(BUILD)/skj-cc-rv: $(SKJ_IR) $(SKJ_RV) $(SKJ_CC) $(SKJ_CPP_LIB) | $(BUILD)
	$(CC) $(CFLAGS) -DCC_RISCV -I$(SKJEGG)cc -I$(SKJEGG)cpp -I$(SKJEGG)ir -DSKJ_INCLUDE_DIR='"$(abspath $(SKJEGG)include)"' -o $@ $(SKJ_IR) $(SKJ_RV) $(SKJ_CC) $(SKJ_CPP_LIB)

SKJ_ALL += $(BUILD)/skj-as-rv
$(BUILD)/skj-as-rv: $(SKJEGG)as/rv_main.c $(SKJ_AS_RV_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c | $(BUILD)
	$(CC) $(CFLAGS) -I$(SKJEGG)as -I$(SKJEGG)ir -I$(SKJEGG)dwarf -o $@ $(SKJEGG)as/rv_main.c $(SKJ_AS_RV_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c

SKJ_ALL += $(BUILD)/skj-ld-rv
$(BUILD)/skj-ld-rv: $(SKJEGG)ld/rv_main.c $(SKJ_LD_RV_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c | $(BUILD)
	$(CC) $(CFLAGS) -I$(SKJEGG)ld -I$(SKJEGG)ir -o $@ $(SKJEGG)ld/rv_main.c $(SKJ_LD_RV_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c

SKJ_ALL += $(BUILD)/skj-ar
$(BUILD)/skj-ar: $(SKJEGG)ar/main.c $(SKJEGG)ld/mapfile.c $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c | $(BUILD)
	$(CC) $(CFLAGS) -I$(SKJEGG)ld -I$(SKJEGG)ir -o $@ $(SKJEGG)ar/main.c $(SKJEGG)ld/mapfile.c $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c

LIBC_SRCS := string ctype stdlib printf numfmt stdio_core stdio assert malloc sbrk errno strerror rand strtod scanf coro threads stat fileops dirent getenv fdio
RT_SRCS := rng
FS_SRCS := fs ramfs ambientfs hostcap devfs romfs ninefs p9_guest
LIBC_FSFLAGS := -DSKJ_FS_INTERPOSE -DFS_WITH_AMBIENT -DFS_WITH_HOSTCAP -DFS_WITH_DEV -DFS_WITH_ROM -DFS_WITH_9P -I$(SKJEGG)fs

$(BUILD)/lib/riscv/crt0.o: $(BUILD)/start_rv.o
	@mkdir -p $(@D) && cp $< $@
$(BUILD)/lib/riscv/va_rv.o: $(BUILD)/va_rv.o
	@mkdir -p $(@D) && cp $< $@

$(BUILD)/lib/riscv/soft64_div.o: $(SKJEGG)runtime/soft64.c | $(BUILD)
	@mkdir -p $(@D)
	$(RV_CC) -std=c99 -O2 -Wall -ffreestanding -march=rv32imfd -mabi=ilp32 -DSOFT64_NO_MULSHIFT -c -o $@ $<

$(BUILD)/lib/riscv/obj/co_switch.o: $(SKJEGG)runtime/co_switch_rv.S $(BUILD)/skj-as-rv | $(BUILD)
	@mkdir -p $(BUILD)/lib/riscv/obj
	@$(BUILD)/skj-as-rv -o $@ $(SKJEGG)runtime/co_switch_rv.S
$(BUILD)/lib/riscv/obj/setjmp.o: $(SKJEGG)runtime/setjmp_rv.S $(BUILD)/skj-as-rv | $(BUILD)
	@mkdir -p $(BUILD)/lib/riscv/obj
	@$(BUILD)/skj-as-rv -o $@ $(SKJEGG)runtime/setjmp_rv.S
$(BUILD)/lib/riscv/libc.a: $(BUILD)/skj-cc-rv $(BUILD)/skj-as-rv $(BUILD)/skj-ar $(BUILD)/lib/riscv/obj/co_switch.o $(BUILD)/lib/riscv/obj/setjmp.o | $(BUILD)
	@mkdir -p $(BUILD)/lib/riscv/obj
	@for s in $(LIBC_SRCS); do \
	    $(BUILD)/skj-cc-rv -DSKJ_LIBC_FLOAT $(LIBC_FSFLAGS) -I$(SKJEGG)include -I$(SKJEGG)libc -o $(BUILD)/lib/riscv/obj/$$s.s $(SKJEGG)libc/$$s.c && \
	    $(BUILD)/skj-as-rv -o $(BUILD)/lib/riscv/obj/$$s.o $(BUILD)/lib/riscv/obj/$$s.s || exit 1; \
	done
	@for s in $(RT_SRCS); do \
	    $(BUILD)/skj-cc-rv -DSKJ_LIBC_FLOAT $(LIBC_FSFLAGS) -I$(SKJEGG)include -I$(SKJEGG)libc -o $(BUILD)/lib/riscv/obj/$$s.s $(SKJEGG)runtime/$$s.c && \
	    $(BUILD)/skj-as-rv -o $(BUILD)/lib/riscv/obj/$$s.o $(BUILD)/lib/riscv/obj/$$s.s || exit 1; \
	done
	@for s in $(FS_SRCS); do \
	    $(BUILD)/skj-cc-rv -DSKJ_LIBC_FLOAT $(LIBC_FSFLAGS) -I$(SKJEGG)include -I$(SKJEGG)libc -o $(BUILD)/lib/riscv/obj/$$s.s $(SKJEGG)fs/$$s.c && \
	    $(BUILD)/skj-as-rv -o $(BUILD)/lib/riscv/obj/$$s.o $(BUILD)/lib/riscv/obj/$$s.s || exit 1; \
	done
	@rm -f $@
	@$(BUILD)/skj-ar rcs $@ $(addprefix $(BUILD)/lib/riscv/obj/,$(addsuffix .o,$(LIBC_SRCS) $(RT_SRCS) $(FS_SRCS))) $(BUILD)/lib/riscv/obj/co_switch.o $(BUILD)/lib/riscv/obj/setjmp.o
$(BUILD)/lib/riscv/fini.o: $(BUILD)/skj-cc-rv $(BUILD)/skj-as-rv | $(BUILD)
	@mkdir -p $(BUILD)/lib/riscv
	@$(BUILD)/skj-cc-rv -I$(SKJEGG)include -o $(BUILD)/lib/riscv/fini.s $(SKJEGG)libc/fini.c
	@$(BUILD)/skj-as-rv -o $@ $(BUILD)/lib/riscv/fini.s

SKJ_ALL += $(BUILD)/skjcc
$(BUILD)/skjcc: $(SKJEGG)driver/main.c $(SKJEGG)ir/exepath.h $(BUILD)/lib/riscv/crt0.o $(BUILD)/lib/riscv/va_rv.o $(BUILD)/lib/riscv/soft64_div.o $(BUILD)/lib/riscv/libc.a $(BUILD)/lib/riscv/fini.o | $(BUILD)
	$(CC) $(CFLAGS) -I$(SKJEGG)ir -DSKJ_LIB_DIR='"$(abspath $(BUILD))/lib"' -o $@ $(SKJEGG)driver/main.c

AR      ?= ar
# The x86-64 assembler.  The vendored backend emits GNU `.intel_syntax noprefix`
# assembly, so the default is the host GNU `as` (intel mode via --64).
X64_ASM      ?= as
X64_ASMFLAGS ?= --64

SKJ_BE_X64 := $(SKJEGG)backend/regalloc_x86.c $(SKJEGG)backend/x86_select.c \
              $(SKJEGG)backend/mc_text.c $(SKJEGG)backend/x86_aot.c
SKJ_KP_AOT_RT := $(SKJEGG)kobold/aot_rt.c $(SKJEGG)kobold/kp_host.c $(SKJEGG)kobold/kp_io.c \
                 $(SKJEGG)libc/numfmt.c $(SKJEGG)kobold/str_core.c \
                 $(SKJEGG)kobold/str_fmt.c $(SKJEGG)kobold/dynarr.c $(SKJEGG)kobold/map.c \
                 $(SKJEGG)kobold/rt_host.c $(SKJEGG)kobold/co_shim.c \
                 $(SKJEGG)runtime/co_switch_x86.S $(SKJEGG)jit/call_guest_x86.S
SKJ_KP_CFLAGS := $(CFLAGS) -DX86_BITS=64 -DKP_FREESTANDING -DKP_REAL=double \
                 -I$(SKJEGG)ir -I$(SKJEGG)jit -I$(SKJEGG)backend -I$(SKJEGG)kobold

# skj-kp: the x86-64 KPM1 AOT compiler (reads a .kpm, writes GNU intel assembly).
SKJ_ALL += $(BUILD)/skj-kp
$(BUILD)/skj-kp: $(SKJEGG)kobold/aot_main.c $(SKJEGG)kobold/kpm.c $(SKJ_IR) $(SKJ_BE_X64) | $(BUILD)
	$(CC) $(CFLAGS) -DX86_BITS=64 -I$(SKJEGG)ir -I$(SKJEGG)backend -I$(SKJEGG)kobold -o $@ $(SKJEGG)kobold/aot_main.c $(SKJEGG)kobold/kpm.c $(SKJ_IR) $(SKJ_BE_X64)

# co.c carries Kobold's own warning set (no -Wpedantic), so it is a separate object.
$(BUILD)/kp_co.o: $(SKJEGG)kobold/co.c | $(BUILD)
	$(CC) -std=c99 -O2 -Wall -Wextra -Wno-unused-parameter -I$(SKJEGG)ir -I$(SKJEGG)jit -I$(SKJEGG)backend -I$(SKJEGG)kobold -c $(SKJEGG)kobold/co.c -o $@

# libkpaot.a: the hosted Kobold runtime an AOT program links against.
$(BUILD)/libkpaot.a: $(SKJ_KP_AOT_RT) $(BUILD)/kp_co.o | $(BUILD)
	@rm -rf $(BUILD)/aot && mkdir -p $(BUILD)/aot
	@for f in $(SKJ_KP_AOT_RT); do o=$(BUILD)/aot/`basename $$f | sed 's/\.[cS]$$/.o/'`; $(CC) $(SKJ_KP_CFLAGS) -c $$f -o $$o || exit 1; done
	$(AR) rcs $@ $(BUILD)/aot/*.o $(BUILD)/kp_co.o

# The Kobold-Pascal front end, built from source rather than a prebuilt seed:
# skj-pc (the Compact Pascal compiler) built for the host compiles kpcom.pas
# (valid Pascal) to native host code, and compiling it with -d KP_TARGET_<T>
# bakes the emitted target in.  So skj-kpc-<target> runs on this host and emits
# that target's KPM1 modules, for any supported target from any host.  The host
# backend vendored here is x86-64; building on an arm64 host needs the arm64
# selector vendored too.
HOST_ARCH := $(shell uname -m)
ifeq ($(filter x86_64 amd64,$(HOST_ARCH)),)
$(error building skj-pc/skj-kpc from kpcom.pas needs an x86-64 host, got $(HOST_ARCH))
endif

SKJ_PASCAL_FE := $(SKJEGG)pascal/lex.c $(SKJEGG)pascal/parse.c \
                 $(SKJEGG)pascal/lower.c $(SKJEGG)pascal/main.c

SKJ_ALL += $(BUILD)/skj-pc-x86-64
$(BUILD)/skj-pc-x86-64: $(SKJ_PASCAL_FE) $(SKJ_IR) $(SKJ_BE_X64) | $(BUILD)
	$(CC) $(CFLAGS) -DX86_BITS=64 -DSKJ_LP64=1 -I$(SKJEGG)pascal -I$(SKJEGG)ir -I$(SKJEGG)backend -o $@ $(SKJ_PASCAL_FE) $(SKJ_IR) $(SKJ_BE_X64)

# The Compact Pascal host runtime (native libc): the managed string/array and IO
# runtime every skj-kpc-<target> links.
$(BUILD)/pascal_rt_host.o: $(SKJEGG)runtime/pascal_rt.c | $(BUILD)
	$(CC) -std=c99 -O2 -DPAS_HOST -c -o $@ $<

# skj-kpc / skj-kpc-x86-64: the Kobold front end that emits x86-64 KPM1 modules,
# so 'skj-kpc --emit-kpm foo.pas' turns Kobold source into a module with no fpc.
SKJ_ALL += $(BUILD)/skj-kpc $(BUILD)/skj-kpc-x86-64
$(BUILD)/skj-kpc: $(BUILD)/skj-pc-x86-64 $(SKJEGG)tests/pascal_kpcom_host.c $(BUILD)/pascal_rt_host.o $(SKJEGG)kobold/kpcom.pas | $(BUILD)
	$(BUILD)/skj-pc-x86-64 -d KOBOLD -d KP_TARGET_X64 -o $(BUILD)/kpcom-x86-64-fe.s $(SKJEGG)kobold/kpcom.pas
	$(X64_ASM) $(X64_ASMFLAGS) $(BUILD)/kpcom-x86-64-fe.s -o $(BUILD)/kpcom-x86-64-fe.o
	$(CC) -no-pie $(BUILD)/kpcom-x86-64-fe.o $(SKJEGG)tests/pascal_kpcom_host.c $(BUILD)/pascal_rt_host.o -lm -o $@
$(BUILD)/skj-kpc-x86-64: $(BUILD)/skj-kpc | $(BUILD)
	cp -f $(BUILD)/skj-kpc $@

# skj-kp-rv: the KPM1 -> RV32 asm AOT compiler, a host binary.  Link its output with
# the freestanding runtime tier (a later step) or the hosted libkpaot-rv.
SKJ_ALL += $(BUILD)/skj-kp-rv
$(BUILD)/skj-kp-rv: $(SKJEGG)kobold/aot_main.c $(SKJEGG)kobold/kpm.c $(SKJ_IR) $(SKJ_RV) | $(BUILD)
	$(CC) $(CFLAGS) -DKP_AOT_RV -I$(SKJEGG)ir -I$(SKJEGG)backend -I$(SKJEGG)kobold -o $@ $(SKJEGG)kobold/aot_main.c $(SKJEGG)kobold/kpm.c $(SKJ_IR) $(SKJ_RV)

# skj-kpc-rv: the Kobold front end that emits rv KPM1 modules.
SKJ_ALL += $(BUILD)/skj-kpc-rv
$(BUILD)/skj-kpc-rv: $(BUILD)/skj-pc-x86-64 $(SKJEGG)tests/pascal_kpcom_host.c $(BUILD)/pascal_rt_host.o $(SKJEGG)kobold/kpcom.pas | $(BUILD)
	$(BUILD)/skj-pc-x86-64 -d KOBOLD -d KP_TARGET_RV -o $(BUILD)/kpcom-rv-fe.s $(SKJEGG)kobold/kpcom.pas
	$(X64_ASM) $(X64_ASMFLAGS) $(BUILD)/kpcom-rv-fe.s -o $(BUILD)/kpcom-rv-fe.o
	$(CC) -no-pie $(BUILD)/kpcom-rv-fe.o $(SKJEGG)tests/pascal_kpcom_host.c $(BUILD)/pascal_rt_host.o -lm -o $@

# skj-run: the guest runner.  The architectures compiled in
# are fixed at vendoring time; skj-run reads the ELF header to
# pick between them.
SKJ_EMU := $(SKJEGG)emu/main.c $(SKJEGG)emu/guest.c $(SKJEGG)emu/elf32.c $(SKJEGG)emu/elf64.c $(SKJEGG)emu/hostplat.c $(SKJEGG)emu/sched.c $(SKJEGG)emu/procfs.c $(SKJEGG)fs/p9_server.c $(SKJEGG)emu/rv32.c $(SKJEGG)emu/rv_user.c $(SKJEGG)emu/rv_gdb.c $(SKJEGG)emu/gdbstub.c $(SKJEGG)dwarf/dwread.c $(SKJEGG)ir/arena.c
SKJ_EMU_LDLIBS :=
SKJ_ALL += $(BUILD)/skj-run
$(BUILD)/skj-run: $(SKJ_EMU) | $(BUILD)
	$(CC) $(CFLAGS) -DEMU_COLDFIRE=0 -DEMU_RV32=1 -DEMU_MIPS32=0 -DEMU_HV=0 -DSKJ_RV_GDB -DSKJ_DWARF_BACKTRACE -I$(SKJEGG)dwarf -I$(SKJEGG)ir -I$(SKJEGG)emu -I$(SKJEGG)fs -o $@ $(SKJ_EMU) -lm $(SKJ_EMU_LDLIBS)

SKJ_VDSO += $(BUILD)/vdso-rv.elf
SKJ_ALL += $(BUILD)/vdso-rv.elf
$(BUILD)/vdso-rv.o: $(SKJEGG)runtime/vdso.c $(SKJEGG)include/skj_vdso.h $(BUILD)/skj-cc-rv $(BUILD)/skj-as-rv | $(BUILD)
	$(BUILD)/skj-cc-rv -I$(SKJEGG)include -o $(BUILD)/vdso-rv.s $(SKJEGG)runtime/vdso.c
	$(BUILD)/skj-as-rv -o $@ $(BUILD)/vdso-rv.s
$(BUILD)/vdso-rv.elf: $(BUILD)/vdso-rv.o $(SKJEGG)runtime/vdso_rv.ld $(BUILD)/skj-ld-rv
	$(BUILD)/skj-ld-rv -T $(SKJEGG)runtime/vdso_rv.ld -o $@ $(BUILD)/vdso-rv.o

$(BUILD)/start_rv.o: $(SKJEGG)runtime/start_rv.S $(SKJEGG)runtime/crt_entry_rv.S $(SKJEGG)runtime/syscall_rv.S $(SKJEGG)runtime/i64_rv.S | $(BUILD)
	$(RV_AS) -I$(SKJEGG) -I$(SKJEGG)runtime -march=rv32im -mabi=ilp32 -o $@ $(SKJEGG)runtime/start_rv.S

$(BUILD)/va_rv.o: $(SKJEGG)runtime/va_rv.c | $(BUILD)
	$(RV_CC) -std=c99 -O2 -Wall -ffreestanding -march=rv32imfd -mabi=ilp32 -c -o $@ $<

# Every tool's main.c includes "version.h", so generate it from the release
# number plus the commit this tree was vendored from.
$(BUILD)/version.h: $(SKJEGG)version.mk $(SKJEGG)skjegg.mk | $(BUILD)
	@printf '#ifndef SKJ_VERSION_H\n#define SKJ_VERSION_H\n#define SKJ_VERSION "%s"\n#endif\n' '$(SKJ_FULL_VERSION)' > $@

$(SKJ_ALL): $(BUILD)/version.h

skjegg: $(SKJ_ALL)
.PHONY: skjegg

$(BUILD):
	mkdir -p $@
