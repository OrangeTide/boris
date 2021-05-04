TYPE = dll
OUT = util
SRCDIR = util
SRCS = example1.c example2.c
CPPFLAGS = -Icommon/
CFLAGS = -Wall -W -O3 -pthread
LDFLAGS = -pthread
