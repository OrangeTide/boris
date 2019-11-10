# requires GNU Make to build

CFLAGS += -Wall -W -g
# CFLAGS += -O3
# LDFLAGS += -Wl,-Map=stackvm.map
# LDFLAGS += -rdynamic
CPPFLAGS += -D_XOPEN_SOURCE=700 -D_POSIX_C_SOURCE=200809L -I../

all ::
clean ::
clean-all :: clean
tests ::

## a test implementation and some tests
S.demovm := demovm.c ../stackdump.c
O.demovm := $(S.demovm:%.c=%.o)
demovm : $(O.demovm) ../libstackvm.a
all :: demovm
clean :: ; $(RM) demovm $(O.demovm)
tests :: demovm ex1.qvm ex2.qvm ex3.qvm
	./demovm ex1.qvm
	./demovm ex2.qvm
	./demovm ex3.qvm

## use the q3vm tools:
TOOLSDIR := ../../stackvm-tools
Q3ASM := $(TOOLSDIR)/q3asm
Q3LCC := $(TOOLSDIR)/q3lcc

# build the tools if they don't exist
$(Q3ASM) $(Q3LCC) : ; $(MAKE) -C $(TOOLSDIR)
# clean the tools
clean-all :: tools-clean-all
tools-clean-all : ; $(MAKE) -C $(TOOLSDIR) clean

%.qvm : %.asm | $(Q3ASM)
	$(Q3ASM) -o $@ $^

%.asm : %.c | $(Q3LCC)
	$(Q3LCC) $^

.PRECIOUS: %.asm

## tests

# ex1
all :: ex1.qvm
clean :: ; $(RM) ex1.qvm ex1.asm

# ex2
all :: ex2.qvm
clean :: ; $(RM) ex2.qvm ex2.asm
ex2.qvm : ex2.asm ex2_syscalls.asm

# ex3
all :: ex3.qvm
clean :: ; $(RM) ex3.qvm ex3.asm
ex3.qvm : ex3.asm ex2_syscalls.asm
