project( boris C )
cmake_minimum_required( VERSION 3.8 )

if ( ${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR} )
	message( FATAL_ERROR "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there. You may need to remove CMakeCache.txt." )
endif()

set( CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin )
set( CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin )

set( CMAKE_BUILD_TYPE Debug )

SET( CMAKE_AR "gcc-ar" )
SET( CMAKE_C_ARCHIVE_CREATE "<CMAKE_AR> qcs <TARGET> <LINK_FLAGS> <OBJECTS>"  )
SET( CMAKE_C_ARCHIVE_FINISH true )

set( THREADS_PREFER_PTHREAD_FLAG ON )
find_package( Threads REQUIRED )

add_subdirectory( thirdparty )
add_subdirectory( scrypt )
add_subdirectory( passwd )
add_subdirectory( log )
add_subdirectory( util )
add_subdirectory( help )

include_directories( include )

file( GLOB boris_SOURCES
	server/boris.c
)

add_executable( boris ${boris_SOURCES} )

target_compile_options( boris
	PRIVATE -Wall -W -O2
	PUBLIC -flto -g
	)

target_compile_definitions( boris
	PRIVATE NTEST
	PRIVATE NDEBUG
	)

target_link_libraries( boris
	PRIVATE mud
	)

target_include_directories( boris
	PUBLIC include
	PUBLIC server
	)

file( GLOB mud_SOURCES
	channel/channel.c
	character/character.c
	crypt/base64.c
	crypt/sha1.c
	crypt/sha1crypt.c
	fdb/fdbfile.c
	room/room.c
	server/acs.c
	server/boris.c
	server/buf.c
	server/common.c
	server/config.c
	server/form.c
	server/freelist.c
	server/game.c
	server/login.c
	server/menu.c
	server/telnetclient.c
	server/user.c
	stackvm/stackvm.c
	task/command.c
	task/comutil.c
	util/util.c
	worldclock/worldclock.c
)

add_library( mud ${mud_SOURCES} )

target_compile_options( mud
	PRIVATE -Wall -W -O2
	PUBLIC -flto -g
	)

target_compile_definitions( mud
	PRIVATE NTEST
	PRIVATE NDEBUG
	)

target_link_libraries( mud
	PUBLIC Threads::Threads
	PUBLIC lmdb
	PUBLIC dyad
	PUBLIC mth
	PUBLIC scrypt
	PUBLIC log
	PUBLIC util
	PUBLIC helplib
	)

target_include_directories( mud
	PUBLIC include
	PRIVATE server
	PUBLIC channel
	PUBLIC character
	PUBLIC crypt
	PUBLIC fdb
	PUBLIC room
	PUBLIC task
	PUBLIC util
	PUBLIC worldclock
	)
