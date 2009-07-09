#!/bin/make -f
##############################################################################
### detect GCC compiler
ifeq ($(findstring gcc,$(shell $(CC) -v 2>&1)),gcc)
HAS_GCC:=1
GCC_MACHINE:=$(shell $(CC) -dumpmachine)
endif
##############################################################################
### Detect if the GCC compiler targets windows
ifneq ($(findstring mingw32,$(GCC_MACHINE))$(findstring cygwin,$(GCC_MACHINE)),)
GCC_WIN32:=1
EXE:=.exe

# rule for windows executables
%.exe : %.o
	$(CC) $(LDFLAGS) $(TARGET_ARCH) $^ $(LOADLIBES) $(LDLIBS) -o $@

endif
##############################################################################
### CPPFLAGS - C preprocessor flags
# disable debugging code and output.
CPPFLAGS += -DNDEBUG
# disable trace log output.
CPPFLAGS += -DNTRACE
# disable unit test.
CPPFLAGS += -DNTEST
##############################################################################
### CFLAGS - C compiler flags
ifneq ($(HAS_GCC),)
	# flags for GCC compilers
	CFLAGS := -Wall -Wextra -pedantic -std=gnu99 -g
	ifneq ($(GCC_WIN32),)
		CFLAGS += -mno-cygwin
	endif
else
	# for other compilers
	CFLAGS := -Wall
endif
##############################################################################
_all : all
.PHONY : all _all clean clean-all distclean documentation
##############################################################################
## modules - configuration defining targets
include mod-*.mk
##############################################################################
## rules
all : $(foreach i,$(MODULES),$(EXEC_$i))
clean :
	$(RM) $(foreach i,$(MODULES),$(CLEAN_$i))
clean-all : clean
distclean : clean-all
documentation : $(foreach i,$(MODULES),documentation-$i)
