#!/usr/bin/make -f

##############################################################################
# universal settings for all platforms and architectures
##############################################################################

CFLAGS:=-Wall -Wextra -Wuninitialized -Wshadow -Wsign-compare -Wconversion -Wstrict-prototypes -Wstrict-aliasing -Wpointer-arith -Wcast-align  -Wold-style-definition -Wredundant-decls -Wnested-externs -std=gnu99 -pedantic 
# debugging
CFLAGS+=-g -O1
# profiling
# CFLAGS+=-pg
# optimization
# CFLAGS+=-Os 
# enable the following for dead code elimination
#CFLAGS+=-ffunction-sections -fdata-sections -Wl,--gc-sections

# turn on POSIX/susv3 
CPPFLAGS:=-D_XOPEN_SOURCE=600

#CPPFLAGS+=-DNDEBUG
CPPFLAGS+=-DNTRACE

# LDLIBS:=

all : boris

boris : boris.c

clean ::
	$(RM) boris

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
