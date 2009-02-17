#!/usr/bin/make -f

OS:=$(shell uname -s)

##############################################################################
# universal settings for all platforms and architectures
##############################################################################

# detect if we're using GCC and use gcc-specific flags
ifeq ($(findstring gcc,$(shell $(CC) -v 2>&1)),gcc)
CFLAGS:=-Wall -Wextra -Wshadow -Wsign-compare -Wstrict-prototypes -Wstrict-aliasing -Wpointer-arith -Wcast-align  -Wold-style-definition -Wredundant-decls -Wnested-externs -std=gnu99 -pedantic -g

ifeq ($(OS),Darwin)
DARWIN_SDK=/Developer/SDKs/MacOSX10.4u.sdk
CFLAGS+=-isysroot $(DARWIN_SDK)
LDFLAGS+=-isysroot $(DARWIN_SDK)
# build universal binary
TARGET_ARCH=-arch i386 -arch ppc
else
# mkdir()'s mode parameter is a short on Darwin which cause warnings with the following.
CFLAGS+=-Wconversion 
endif

# Uninitialized/clobbered variable warning
#CFLAGS+=-Wuninitialized -O1
# profiling
#CFLAGS+=-pg
# optimization
#CFLAGS+=-Os
# enable the following for dead code elimination
#CFLAGS+=-ffunction-sections -fdata-sections -Wl,--gc-sections
endif ## gcc specific bits

# turn on BSD things
CPPFLAGS:=-D_BSD_SOURCE

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
