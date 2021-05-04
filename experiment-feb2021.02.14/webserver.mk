TYPE = exe
OUT = webserver
SRCDIR = webserver
SRCS = webserver.c mongoose.c
CPPFLAGS = -Icommon/ -Iutil/ -DCONFIG_HEADER="<config.h>"
CFLAGS = -Wall -W -O3 -pthread
LDFLAGS = -pthread
