#  Makefile
########################################################################
## Settings
# use V=1 to select verbose output, default is quiet output
ifeq ($(V),1)
QCMD=
QDSC=
else
BOLD:=$(shell tput bold)
NORM:=$(shell tput sgr0)
QCMD=@
QDSC=@echo $1 $(BOLD)$2$(NORM) $3
endif
########################################################################
## Boris MUD project-wide settings
EXEC = bin/mud
SRCS = server/main.c \
       server/server.c
CFLAGS = -Wall -W -O3 -flto -g -pthread
CPPFLAGS = -D_GNU_SOURCE -D_XOPEN_SOURCE=700 -D_POSIX_C_SOURCE=200809L
CPPFLAGS += -Iserver/
OBJBUILD = build/
PKGS = libuv
########################################################################
## http_parser
SRCS += http-parser/http_parser.c
CPPFLAGS += -Ihttp-parser/
########################################################################
## Session
SRCS += session/env.c
CPPFLAGS += -Isession/
########################################################################
## Logging
SRCS += log/log.c
CPPFLAGS += -Ilog/
########################################################################
## Blowfish Crypt
SRCS += libbcrypt/bcrypt.c
CPPFLAGS += -Ilibbcrypt/
########################################################################
## SQLite Amalgamation
# SRCS += sqlite-amalgamation/sqlite3.c
# CFLAGS += -Isqlite-smalgamation/
########################################################################
## LMDB
SRCS += lmdb/libraries/liblmdb/mdb.c \
	lmdb/libraries/liblmdb/midl.c
CPPFLAGS += -Ilmdb/libraries/liblmdb/
########################################################################
## Daemonize
SRCS += daemonize/daemonize.c
CPPFLAGS += -Idaemonize/
########################################################################
## StackVM
SRCS += stackvm/stackvm.c
CPPFLAGS += -Istackvm/
########################################################################
## World Clock
SRCS += worldclock/worldclock.c
CPPFLAGS += -Iworldclock/
########################################################################
# Remember, these are evaluated when expanded ...
OBJS = $(patsubst %.c,$(OBJBUILD)%.o,$(SRCS))
DEPS = $(patsubst %.c,$(OBJBUILD)%.d,$(SRCS))

all :: $(EXEC)
clean ::
	$(call QDSC,"Removing build objects ...",$(OBJS))
	$(QCMD)$(RM) $(OBJS)
clean ::
	$(call QDSC,"Removing temporary dependency files ...",$(DEPS))
	$(QCMD)$(RM) $(DEPS)
clean-all :: clean
	$(call QDSC,"Removing executable ...",$(EXEC))
	$(QCMD)$(RM) $(EXEC)
.PHONY: all clean clean-all
########################################################################
# make use of .d (dependency) files generated with -MMD -MP
-include $(DEPS)
########################################################################
## Rules

# output all .o files under build/ directory
$(OBJBUILD)%.o : %.c
	@mkdir -p $(dir $@)
	$(call QDSC,"Compiling","$<","...")
	$(QCMD)$(CC) $(CFLAGS) $(CPPFLAGS) -MMD -MP -c -o $@ $< $(if $(PKGS),$(shell pkg-config --cflags $(PKGS)))

# build the executable
$(EXEC) : $(OBJS) | $(dir $(EXEC))
	$(call QDSC,"Linking","$@",": $^")
	$(QCMD)$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS) $(if $(PKGS),$(shell pkg-config --cflags --libs $(PKGS)))

# automatically create subdirectory
%/ :
	mkdir -p $@
