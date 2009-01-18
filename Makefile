#!/usr/bin/make -f

##############################################################################
# universal settings for all platforms and architectures
##############################################################################

CFLAGS:=-Wall -Wextra -Wshadow -Wsign-compare -Wconversion -Wstrict-prototypes -Wstrict-aliasing -Wpointer-arith -Wcast-align  -Wold-style-definition -Wredundant-decls -Wnested-externs -std=gnu99 -pedantic -g
# Uninitialized/clobbered variable warning
#CFLAGS+=-Wuninitialized -O1
# profiling
#CFLAGS+=-pg
# optimization
#CFLAGS+=-Os
# enable the following for dead code elimination
#CFLAGS+=-ffunction-sections -fdata-sections -Wl,--gc-sections

# turn on POSIX/susv3 and BSD things
CPPFLAGS:=-D_XOPEN_SOURCE=600 -D_BSD_SOURCE

#CPPFLAGS+=-DNDEBUG
CPPFLAGS+=-DNTRACE
CPPFLAGS+=-DNTEST

# LDLIBS:=

all : boris.stripped

boris.stripped : boris

boris : boris.c

clean ::
	$(RM) boris boris.stripped

# creates executables that are stripped
%.stripped : %
	$(STRIP) -o $@ $^

#makes objects useful for tracing/debugging
#%.debug.o : CPPFLAGS:=$(filter-out -DNDEBUG,$(CPPFLAGS))
#%.debug.o : %.c
#	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -o $@ $<
# creates executables that have debug symbols
#%.debug : CPPFLAGS:=$(filter-out -DNDEBUG,$(CPPFLAGS))
#%.debug : %.c
#	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LOADLIBES) $(LDLIBS) -o $@

##############################################################################
# OS specific settings
##############################################################################
OS:=$(shell uname -s)
ifeq (${OS},Linux)
STRIP:=strip -s -p -R .comment
else
STRIP:=strip -S
endif

##
# Windows build
#
CFLAGS_WIN32:=$(CFLAGS) -D_WIN32_WINNT=0x0501
CPPFLAGS_WIN32:=$(CPPFLAGS)
LDLIBS_WIN32:=-lws2_32

boris.exe : boris.c

clean ::
	$(RM) boris.exe boris.debug.exe

%.win32.o : %.c
	i586-mingw32msvc-gcc -c $(CFLAGS_WIN32) $(CPPFLAGS_WIN32) -o $@ $^

%.debug.exe : %.c
	i586-mingw32msvc-gcc $(CFLAGS_WIN32) $(CPPFLAGS_WIN32) $(LDFLAGS_WIN32) -o $@ $^ $(LDLIBS_WIN32)

.PRECIOUS : %.debug.exe

%.debug.exe : %.win32.o
	i586-mingw32msvc-gcc $(CFLAGS_WIN32) $(LDFLAGS_WIN32) -o $@ $(filter %.win32.o,$^) $(LDLIBS_WIN32)

%.exe : %.debug.exe
	i586-mingw32msvc-strip -s -p -o $@ $(filter %.exe,$^)
