cmake_minimum_required( VERSION 3.12 )
add_library( dyad dyad.c )
target_compile_options( dyad
	PRIVATE -Wall -W -O2
	PUBLIC -g )
target_include_directories( dyad PUBLIC "." )
