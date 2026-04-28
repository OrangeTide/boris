CROSS   = m68k-linux-gnu-
CC      = $(CROSS)gcc
OBJDUMP = $(CROSS)objdump

CFLAGS  = -mcpu=5475 -Os -ffreestanding -nostdlib -Iinclude
LDFLAGS = -T lib/machine.ld -nostdlib -Wl,--build-id=none

OUTDIR  = ../../data/machine
PROGS   = anim/fountain exits/random-portal

CRT     = lib/crt0.o
ELFS    = $(addprefix $(OUTDIR)/,$(addsuffix .elf,$(PROGS)))

all: $(ELFS)

$(OUTDIR)/%.elf: %.o $(CRT) lib/machine.ld
	@mkdir -p $(dir $@)
	$(CC) $(LDFLAGS) -o $@ $(CRT) $<

%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c -o $@ $<

lib/crt0.o: lib/crt0.S
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f lib/*.o anim/*.o exits/*.o $(ELFS)

disasm: all
	@for p in $(ELFS); do $(OBJDUMP) -d $$p; done

.PHONY: all clean disasm
