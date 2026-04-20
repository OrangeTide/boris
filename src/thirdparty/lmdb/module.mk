LIBRARIES += lmdb
lmdb_DIR  := $(dir $(lastword $(MAKEFILE_LIST)))
lmdb_SRCS  = mdb.c midl.c
# Third-party code -- suppress warnings we don't control.
lmdb_CFLAGS = -w
