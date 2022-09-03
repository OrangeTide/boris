cmake_minimum_required(VERSION 3.8)

file(GLOB mud_SOURCES
	channel/channel.c
	character/character.c
	crypt/base64.c
	crypt/sha1.c
	crypt/sha1crypt.c
	fdb/fdbfile.c
	log/eventlog.c
	log/logging.c
	room/room.c
	server/boris.c
	server/common.c
	server/config.c
	stackvm/stackvm.c
	task/command.c
	task/comutil.c
	util/util.c
	worldclock/worldclock.c
)

add_library(passwd passwd.c)

target_compile_options(passwd
	PRIVATE -Wall -W -O2
	PUBLIC -flto -g)

target_link_libraries(passwd
	PUBLIC Threads::Threads
)

target_compile_definitions(passwd
	PRIVATE NTEST
	PRIVATE NDEBUG)

target_include_directories(passwd PUBLIC ".")

add_executable(mkpass mkpass.c)

target_compile_options(mkpass
	PRIVATE -Wall -W -O2
	PUBLIC -flto -g)

target_compile_definitions(mkpass
	PRIVATE NTEST
	PRIVATE NDEBUG)

target_link_libraries(mkpass
	PRIVATE passwd
	PRIVATE scrypt
)
