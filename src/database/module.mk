LIBRARIES    += database
database_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
database_SRCS = muddb.c
database_LIBS = lmdb

EXECUTABLES    += test_muddb
TEST_TARGETS   += test_muddb
test_muddb_DIR := $(database_DIR)
test_muddb_SRCS = test_muddb.c
test_muddb_LIBS = database obj log lmdb
define test_muddb_TESTCMD
$(test_muddb_RUN)
endef
