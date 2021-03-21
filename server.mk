TYPE = exe
# TYPE = disabled
OUT = mud
SRCDIR = server
SRCS = main.c server.c
CPPFLAGS = -D_GNU_SOURCE -D_XOPEN_SOURCE=700 -D_POSIX_C_SOURCE=200809L
# CPPFLAGS += -Iserver/
CFLAGS = -pthread
LDFLAGS = -pthread
PKGS = libuv
USELIBS = daemonize log bcrypt util
