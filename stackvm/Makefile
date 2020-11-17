# requires GNU Make to build

CFLAGS += -Wall -W -g
# CFLAGS += -O3
# LDFLAGS += -Wl,-Map=stackvm.map
# LDFLAGS += -rdynamic
CPPFLAGS += -D_XOPEN_SOURCE=700 -D_POSIX_C_SOURCE=200809L
# Non-deterministic mode is preferred for make dependency checking
ARFLAGS = rvU
# Deterministic mode is preferred for release builds
#ARFLAGS = rvD

all ::
clean ::
clean-all :: clean
tests ::

## the stackvm library
S.libstackvm := stackvm.c
O.libstackvm := $(S.libstackvm:%.c=%.o)
libstackvm.a : libstackvm.a($(O.libstackvm))
all :: libstackvm.a
clean :: ; $(RM) libstackvm.a $(O.libstackvm)
tests ::
	$(MAKE) -C tests tests
