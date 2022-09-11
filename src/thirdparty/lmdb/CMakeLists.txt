cmake_minimum_required( VERSION 3.12 )
add_library( lmdb mdb.c midl.c )
target_compile_options( lmdb
	PRIVATE -Wall -W -O2
	PUBLIC -flto -g )
target_include_directories( lmdb PUBLIC "." )
