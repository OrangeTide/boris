LIBRARIES    += resolve
resolve_DIR  := $(dir $(lastword $(MAKEFILE_LIST)))
resolve_SRCS  = resolve.c
resolve_LIBS  = obj

EXECUTABLES    += test_resolve
TEST_TARGETS   += test_resolve
test_resolve_DIR := $(resolve_DIR)
test_resolve_SRCS = test_resolve.c
test_resolve_LIBS = resolve obj database hashtable log smolvfs lmdb
define test_resolve_TESTCMD
$(test_resolve_RUN)
endef
