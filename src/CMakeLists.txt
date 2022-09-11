add_subdirectory( thirdparty )
add_subdirectory( scrypt )
add_subdirectory( passwd )
add_subdirectory( log )
add_subdirectory( util )
add_subdirectory( help )

add_executable( boris boris.c )

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
	PUBLIC .
	)

file( GLOB mud_SOURCES
	channel/channel.c
	character/character.c
	crypt/base64.c
	crypt/sha1.c
	crypt/sha1crypt.c
	fdb/fdbfile.c
	room/room.c
	stackvm/stackvm.c
	task/command.c
	task/comutil.c
	util/util.c
	worldclock/worldclock.c
	*.c
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
	PUBLIC .
	PUBLIC channel
	PUBLIC character
	PUBLIC crypt
	PUBLIC fdb
	PUBLIC room
	PUBLIC task
	PUBLIC util
	PUBLIC worldclock
	)