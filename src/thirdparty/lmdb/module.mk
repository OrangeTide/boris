LIBRARIES += lmdb
lmdb_DIR  := $(dir $(lastword $(MAKEFILE_LIST)))
lmdb_SRCS  = mdb.c midl.c
