cmake_minimum_required( VERSION 3.12 )
add_library( log log.c eventlog.c )
target_compile_options( log
	PRIVATE -Wall -W -O2
	PUBLIC -g)
target_include_directories( log PUBLIC "." )
target_link_libraries( log PRIVATE mud )
