project(boris C)
cmake_minimum_required(VERSION 3.8)

if ( ${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR} )
	message( FATAL_ERROR "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there. You may need to remove CMakeCache.txt." )
endif()

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

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

add_executable(mud ${mud_SOURCES})

target_compile_options(mud
	PRIVATE -Wall -W -O2
	PUBLIC -flto -g)
target_compile_definitions(mud
	PRIVATE NTEST
	PRIVATE NDEBUG)

target_link_libraries(mud
	PRIVATE Threads::Threads
	PUBLIC telnet
	PUBLIC event_pthreads event_core
	PUBLIC ssh
	PUBLIC microhttpd
	PUBLIC lmdb
	PUBLIC dl
	PUBLIC m
)

target_include_directories(mud
	PUBLIC include channel character crypt fdb log room task util worldclock
)
