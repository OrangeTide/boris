# requires GNU Make to build

CFLAGS += -Wall -W -g
# CFLAGS += -O3
# LDFLAGS += -Wl,-Map=stackvm.map
# LDFLAGS += -rdynamic
CPPFLAGS += -D_XOPEN_SOURCE=700 -D_POSIX_C_SOURCE=200809L

all ::
clean ::
clean-all :: clean
tests ::

##

S.stackvm := stackvm.c stackdump.c
O.stackvm := $(S.stackvm:%.c=%.o)
stackvm : $(O.stackvm)
all :: stackvm
clean :: ; $(RM) stackvm $(O.stackvm)
tests :: stackvm ex1.qvm
	./stackvm ex1.qvm

## use the q3vm tools:
TOOLSDIR := tools
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

all :: ex1.qvm
clean :: ; $(RM) ex1.qvm ex1.asm
