DIR = .
SRCS = \
	boris.c \
	config.c \
	channel/channel.c \
	character/character.c \
	crypt/base64.c \
	crypt/sha1.c \
	crypt/sha1crypt.c \
	fdb/fdbfile.c \
	log/eventlog.c \
	log/logging.c \
	room/room.c \
	server/common.c \
	task/command.c \
	task/comutil.c \
	util/util.c \
	worldclock/worldclock.c
CFLAGS = -flto -pthread
ifeq ($(FLAVOR),release)
CPPFLAGS = -DNTEST -DNDEBUG
endif
LDFLAGS = -flto -pthread
LDLIBS = -lm
CPPFLAGS = -Iinclude/ -Ichannel/ -Icharacter/ -Icrypt/ -Ifdb/ -Ilog/ -Iroom/ -Itask/ -Iutil/ -Iworldclock/
PKGS = libtelnet libevent_pthreads libevent_core libssh libmicrohttpd lmdb
$(call generate-exe,mud)
