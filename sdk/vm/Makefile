# Build the example VM guest programs with the vendored skjegg RV32 toolchain.
#
# The tools are host executables built by the main boris build. Point BIN at
# them and run this after that build:
#
#   make -C sdk/vm BIN=$(pwd)/_out/<os>-<arch>/bin
#
# Output ELFs go to DEST (data/vm by default), where the runtime's
# vm.image_path looks for program images. This is a separate step, not part of
# the main build, because the tools run on the host: a cross-compiled boris
# build produces cross tools that cannot run here.

BIN  ?= ../../_out/x86_64-linux-gnu/bin
DEST ?= ../../data/vm

SKJCC := $(BIN)/skj-cc-rv
SKJAS := $(BIN)/skj-as-rv
SKJLD := $(BIN)/skj-ld-rv

RT_OBJS := crt0.o stubs.o imports.o

.PHONY: all clean
all: $(DEST)/hello.elf $(DEST)/agent.elf $(DEST)/look.elf

$(DEST):
	mkdir -p $@

crt0.o: crt0.S
	$(SKJAS) -o $@ $<

stubs.o: stubs.S
	$(SKJAS) -o $@ $<

imports.o: imports.S
	$(SKJAS) -o $@ $<

verb_rt.s: verb_rt.c include/vmsys.h include/verb.h
	$(SKJCC) -Iinclude -o $@ $<

verb_rt.o: verb_rt.s
	$(SKJAS) -o $@ $<

hello.s: examples/hello.c include/vmsys.h
	$(SKJCC) -Iinclude -o $@ $<

hello.o: hello.s
	$(SKJAS) -o $@ $<

agent.s: examples/agent.c include/vmsys.h include/verb.h
	$(SKJCC) -Iinclude -o $@ $<

agent.o: agent.s
	$(SKJAS) -o $@ $<

cmd_crt.o: cmd_crt.S
	$(SKJAS) -o $@ $<

cmd_rt.s: cmd_rt.c include/vmsys.h include/cmd.h
	$(SKJCC) -Iinclude -o $@ $<

cmd_rt.o: cmd_rt.s
	$(SKJAS) -o $@ $<

look.s: examples/look.c include/vmsys.h include/cmd.h
	$(SKJCC) -Iinclude -o $@ $<

look.o: look.s
	$(SKJAS) -o $@ $<

# A one-shot program supplies main(); a verb program links the event-loop
# runtime (verb_rt.o) that supplies main() and calls the program's verb_event.
$(DEST)/hello.elf: $(RT_OBJS) hello.o | $(DEST)
	$(SKJLD) -T vm.ld -o $@ crt0.o hello.o stubs.o imports.o

$(DEST)/agent.elf: $(RT_OBJS) verb_rt.o agent.o | $(DEST)
	$(SKJLD) -T vm.ld -o $@ crt0.o agent.o verb_rt.o stubs.o imports.o

# A command verb links cmd_crt.o (typed-slot entry) and cmd_rt.o (the argument
# accessors) in place of crt0.o, and supplies main().
$(DEST)/look.elf: stubs.o imports.o cmd_crt.o cmd_rt.o look.o | $(DEST)
	$(SKJLD) -T vm.ld -o $@ cmd_crt.o look.o cmd_rt.o stubs.o imports.o

clean:
	rm -f *.o hello.s agent.s verb_rt.s cmd_rt.s look.s
