SUBDIRS = \
	thirdparty/lmdb thirdparty/mth thirdparty/tiny-aes \
	log scrypt util help iox net passwd obj entity rpg combat database \
	security muddb-tool daemonize coldfire machine verb

LIBRARIES    += hashtable
hashtable_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
hashtable_SRCS = hashtable.c

EXECUTABLES        += test_hashtable
test_hashtable_DIR := $(hashtable_DIR)
test_hashtable_SRCS = test_hashtable.c
test_hashtable_LIBS = log

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
	menu.c \
	telnetclient.c \
	user.c \
	acs.c \
	channel/channel.c \
	character/character.c \
	crypt/base64.c \
	crypt/sha1.c \
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
	worldclock/worldclock.c \
	invite.c \
	web/server/webclient.c \
	web/server/weblogin.c \
	web/server/webserver.c \
	machine/obj_program.c \
	machine/objref.c \
	machine/program.c
boris_LIBS = \
	daemonize hashtable log scrypt util help iox net passwd obj entity rpg \
	database security machine coldfire lmdb mth tinyaes
