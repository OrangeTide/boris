TYPE = lib
OUT = lmdb
SRCDIR = lmdb
SRCS = libraries/liblmdb/mdb.c \
	libraries/liblmdb/midl.c
PROVIDE_CFLAGS = -Ilmdb/libraries/liblmdb/
