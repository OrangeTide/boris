cmake_minimum_required( VERSION 3.8 )

add_library( scrypt
	crypto_aes.c
	crypto_aesctr.c
	crypto_entropy.c
	crypto_scrypt.c
	crypto_scrypt_smix.c
	humansize.c
	memlimit.c
	scryptenc.c
	sha256.c
	)
target_compile_options( scrypt
	PRIVATE -Wall -W -O2
	PUBLIC -flto -g
	)
target_include_directories( scrypt PUBLIC "." )

# TODO: create and run tests
#add_executable( test_scrypt test_scrypt.c )
#target_link_libraries( test_scrypt PUBLIC scrypt )
