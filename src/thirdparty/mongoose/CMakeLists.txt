cmake_minimum_required( VERSION 3.12 )
add_library( mongoose mongoose.c )
target_compile_options( mongoose
	PRIVATE -Wall -W -O2
	PUBLIC -g )
target_include_directories( mongoose PUBLIC "." )
