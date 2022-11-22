cmake_minimum_required( VERSION 3.12 )
add_library( mth mth.c msdp.c telopt.c )
target_link_libraries( mth
	PUBLIC z
	PUBLIC log
	PUBLIC dyad
	PUBLIC mud
)
target_compile_options( mth
	PRIVATE -Wall -W -O2
	PUBLIC -g )
target_include_directories( mth PUBLIC "." )
