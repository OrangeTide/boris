cmake_minimum_required( VERSION 3.19 )
add_library( util util.c grow.c )
target_compile_options( util
	PRIVATE -Wall -W -O2
	PUBLIC -g)
target_include_directories( util PUBLIC "." )
target_link_libraries( util PRIVATE log )
