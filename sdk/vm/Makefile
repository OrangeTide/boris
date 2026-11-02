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
LIBC_SRCS := string ctype stdlib printf numfmt stdio_core stdio assert malloc \
             sbrk errno strerror rand strtod scanf coro threads stat fileops \
             dirent getenv fdio
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

.PHONY: all libc userland verbs clean
all: verbs userland

# ---------------------------------------------------------------------------
# The libc SDK
# ---------------------------------------------------------------------------
libc: $(LIBC_A) $(LIBC_CRT) $(LIBC_FINI)

$(B) $(B)/obj $(B)/bin $(DEST) $(DEST)/bin:
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
