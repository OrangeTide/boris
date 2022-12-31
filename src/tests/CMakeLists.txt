cmake_minimum_required( VERSION 3.12 )

add_executable( test_lws test_lws.c )

target_compile_options( test_lws PRIVATE -Wall -W -O2 -g )

target_link_libraries( test_lws
	PRIVATE websockets
	)
