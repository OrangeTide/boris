SUBDIRS = \
	thirdparty/lmdb thirdparty/mth thirdparty/tiny-aes \
	thirdparty/smolvfs \
	crypt \
	log scrypt util help iox net passwd obj entity rpg combat database \
	security muddb-tool daemonize verb rv32 vm resolve

LIBRARIES    += hashtable
hashtable_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
hashtable_SRCS = hashtable.c

EXECUTABLES        += test_hashtable
TEST_TARGETS       += test_hashtable
test_hashtable_DIR := $(hashtable_DIR)
test_hashtable_SRCS = test_hashtable.c
test_hashtable_LIBS = log
define test_hashtable_TESTCMD
$(test_hashtable_RUN)
endef

EXECUTABLES  += test_mcp
TEST_TARGETS += test_mcp
test_mcp_DIR := $(hashtable_DIR)
test_mcp_SRCS = test_mcp.c
test_mcp_LIBS = util log
define test_mcp_TESTCMD
$(test_mcp_RUN)
endef

# --- unit tests extracted from embedded #ifndef NTEST blocks -----------------

EXECUTABLES  += test_freelist
TEST_TARGETS += test_freelist
test_freelist_DIR := $(hashtable_DIR)
test_freelist_SRCS = test_freelist.c
test_freelist_LIBS = log
define test_freelist_TESTCMD
$(test_freelist_RUN)
endef

EXECUTABLES  += test_acs
TEST_TARGETS += test_acs
test_acs_DIR := $(hashtable_DIR)
test_acs_SRCS = test_acs.c
test_acs_LIBS = log
define test_acs_TESTCMD
$(test_acs_RUN)
endef

EXECUTABLES  += test_config
TEST_TARGETS += test_config
test_config_DIR := $(hashtable_DIR)
test_config_SRCS = test_config.c
test_config_LIBS = util log
define test_config_TESTCMD
$(test_config_RUN)
endef

EXECUTABLES  += test_sha1
TEST_TARGETS += test_sha1
test_sha1_DIR := $(hashtable_DIR)
test_sha1_SRCS = crypt/test_sha1.c
define test_sha1_TESTCMD
$(test_sha1_RUN)
endef

EXECUTABLES  += test_sha1crypt
TEST_TARGETS += test_sha1crypt
test_sha1crypt_DIR := $(hashtable_DIR)
test_sha1crypt_SRCS = crypt/test_sha1crypt.c
test_sha1crypt_LIBS = crypt util log
define test_sha1crypt_TESTCMD
$(test_sha1crypt_RUN)
endef

EXECUTABLES  += test_heapqueue
TEST_TARGETS += test_heapqueue
test_heapqueue_DIR := $(hashtable_DIR)
test_heapqueue_SRCS = test_heapqueue.c
test_heapqueue_LIBS = log
define test_heapqueue_TESTCMD
$(test_heapqueue_RUN)
endef

EXECUTABLES  += test_bitmap
TEST_TARGETS += test_bitmap
test_bitmap_DIR := $(hashtable_DIR)
test_bitmap_SRCS = test_bitmap.c
test_bitmap_LIBS = log
define test_bitmap_TESTCMD
$(test_bitmap_RUN)
endef

EXECUTABLES  += test_character
TEST_TARGETS += test_character
test_character_DIR := $(hashtable_DIR)
test_character_SRCS = character/test_character.c character/character.c freelist.c
test_character_LIBS = obj database hashtable log smolvfs lmdb
define test_character_TESTCMD
$(test_character_RUN)
endef

EXECUTABLES += boris
boris_DIR   := $(dir $(lastword $(MAKEFILE_LIST)))
boris_SRCS = \
	boris.c \
	buf.c \
	common.c \
	config.c \
	fds.c \
	form.c \
	freelist.c \
	game.c \
	login.c \
	mcp.c \
	menu.c \
	telnetclient.c \
	user.c \
	acs.c \
	channel/channel.c \
	character/character.c \
	crypt/sha1crypt.c \
	room/room.c \
	cmd/cmd.c \
	cmd/cmdutil.c \
	cmd/character.c \
	cmd/chsay.c \
	cmd/emote.c \
	cmd/help.c \
	cmd/look.c \
	cmd/move.c \
	cmd/pose.c \
	cmd/quit.c \
	cmd/resist.c \
	cmd/roll.c \
	cmd/roomget.c \
	cmd/say.c \
	cmd/show_room.c \
	cmd/stat.c \
	cmd/time.c \
	cmd/yell.c \
	cmd/charset.c \
	cmd/edit.c \
	cmd/grant.c \
	cmd/chown.c \
	worldclock/worldclock.c \
	invite.c \
	web/server/webclient.c \
	web/server/weblogin.c \
	web/server/webserver.c
boris_LIBS = \
	verb vm rv32 resolve \
	crypt daemonize hashtable log scrypt util help iox net passwd obj entity rpg \
	database security lmdb mth tinyaes
