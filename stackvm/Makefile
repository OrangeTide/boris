CFLAGS += -Wall -W -g
# CFLAGS += -O3
# LDFLAGS += -Wl,-Map=stackvm.map
# LDFLAGS += -rdynamic
CPPFLAGS += -D_XOPEN_SOURCE=700 -D_POSIX_C_SOURCE=200809L

all ::
clean ::
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
%.qvm : %.asm
	tools/q3asm -o $@ $^

%.asm : %.c
	tools/q3lcc $^

.PRECIOUS: %.asm

all :: ex1.qvm
clean :: ; $(RM) ex1.qvm ex1.asm
