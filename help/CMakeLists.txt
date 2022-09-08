cmake_minimum_required( VERSION 3.8 )

add_library( helplib help.c )
target_compile_options( helplib
	PRIVATE -Wall -W -O2
	PUBLIC -flto -g)
target_include_directories( helplib PUBLIC "." )
target_link_libraries( helplib
	PRIVATE mud
	PRIVATE log
	PRIVATE util
	)
