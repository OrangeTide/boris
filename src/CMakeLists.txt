include_directories( AFTER
	${CMAKE_CURRENT_BINARY_DIR}/thirdparty/libwebsockets/
	thirdparty/libwebsockets/include/
	)
link_directories( AFTER
	${CMAKE_CURRENT_BINARY_DIR}/thirdparty/libwebsockets/lib/
	)

add_subdirectory( thirdparty )
add_subdirectory( scrypt )
add_subdirectory( passwd )
add_subdirectory( log )
add_subdirectory( util )
add_subdirectory( help )
add_subdirectory( tests )
add_subdirectory( web )

add_executable( boris boris.c )

target_compile_options( boris
	PRIVATE -Wall -W -O2
	PUBLIC -g
	)

target_compile_definitions( boris
	PRIVATE NTEST
	PRIVATE NDEBUG
	)

target_link_libraries( boris
	PRIVATE mud
	PRIVATE websockets
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
	acs.c
	boris.c
	buf.c
	common.c
	config.c
	form.c
	freelist.c
	game.c
	login.c
	menu.c
	telnetclient.c
	user.c
  web/server/webserver.c
)

add_library( mud ${mud_SOURCES} )

target_compile_options( mud
	PRIVATE -Wall -W -O2
	PUBLIC -g
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
	PUBLIC jsmn
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
  PUBLIC web/server
	)
