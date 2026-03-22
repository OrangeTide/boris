BORIS_SRCS += \
	src/channel/channel.c \
	src/character/character.c \
	src/crypt/base64.c \
	src/crypt/sha1.c \
	src/crypt/sha1crypt.c \
	src/fdb/fdbfile.c \
	src/room/room.c \
	src/stackvm/stackvm.c \
	src/task/command.c \
	src/task/comutil.c \
	src/worldclock/worldclock.c \
	src/acs.c \
	src/boris.c \
	src/buf.c \
	src/common.c \
	src/config.c \
	src/fds.c \
	src/form.c \
	src/freelist.c \
	src/game.c \
	src/login.c \
	src/menu.c \
	src/telnetclient.c \
	src/user.c \
	src/web/server/webserver.c

INCLUDES += \
	-Isrc \
	-Isrc/channel \
	-Isrc/character \
	-Isrc/crypt \
	-Isrc/fdb \
	-Isrc/room \
	-Isrc/task \
	-Isrc/worldclock \
	-Isrc/web/server
