# TYPE = exe
TYPE = disabled
OUT = authserver
SRCDIR = authserver
SRCS = auth.c auth_rpc.x
CPPFLAGS = -Icommon/ -Iutil/ -DCONFIG_HEADER="<config.h>"
CFLAGS = -Wall -W -O3 -pthread
LDFLAGS = -pthread
