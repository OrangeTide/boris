#!/usr/bin/make -f

##############################################################################
# universal settings for all platforms and architectures
##############################################################################

CFLAGS:=-Wall -Wextra -Wuninitialized -Wshadow -Wsign-compare -Wconversion -Wstrict-prototypes -fstrict-aliasing -Wstrict-aliasing -Wpointer-arith -Wcast-align -Wstrict-prototypes -Wold-style-definition -Wredundant-decls -Wnested-externs -std=c99 -pedantic 
# debugging and profiling
CFLAGS+=-g -pg -O1
# optimization
# CFLAGS+=-Os 
# enable the following for dead code elimination
#CFLAGS+=-ffunction-sections -fdata-sections -Wl,--gc-sections

# turn on POSIX/susv3 
CPPFLAGS:=-D_XOPEN_SOURCE=600

# LDLIBS:=

boris : boris.c


