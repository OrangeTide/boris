BORIS_SRCS += \
	src/channel/channel.c \
	src/character/character.c \
	src/crypt/base64.c \
	src/crypt/sha1.c \
	src/crypt/sha1crypt.c \
	src/room/room.c \
	src/cmd/cmd.c \
	src/cmd/cmdutil.c \
	src/cmd/character.c \
	src/cmd/chsay.c \
	src/cmd/emote.c \
	src/cmd/help.c \
	src/cmd/look.c \
	src/cmd/move.c \
	src/cmd/pose.c \
	src/cmd/quit.c \
	src/cmd/resist.c \
	src/cmd/roll.c \
	src/cmd/roomget.c \
	src/cmd/say.c \
	src/cmd/stat.c \
	src/cmd/time.c \
	src/cmd/yell.c \
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
	src/hashtable.c \
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
	-Isrc/room \
	-Isrc/cmd \
	-Isrc/worldclock \
	-Isrc/web/server

# --- Test targets ---
TEST_SRCS += src/test_hashtable.c
TEST_BINS += $(BINDIR)/test_hashtable
TEST_HT_OBJS := $(BUILDDIR)/src/test_hashtable.o $(BUILDDIR)/src/log/log.o

$(BINDIR)/test_hashtable: $(TEST_HT_OBJS) | $(BINDIR)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)
