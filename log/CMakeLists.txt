cmake_minimum_required( VERSION 3.8 )
add_library( log log.c eventlog.c )
target_compile_options( log
	PRIVATE -Wall -W -O2
	PUBLIC -flto -g)
target_include_directories( log PUBLIC "." )
target_link_libraries( log
	PUBLIC mud
	)
