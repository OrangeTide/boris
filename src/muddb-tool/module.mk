LIBRARIES += muddb_export
muddb_export_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
muddb_export_SRCS = muddb_export.c
muddb_export_LIBS = database obj log
muddb_export_EXPORTED_CPPFLAGS = -I$(muddb_export_DIR)

EXECUTABLES    += muddb-tool
muddb-tool_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
muddb-tool_SRCS = muddb-tool.c
muddb-tool_LIBS = muddb_export database obj hashtable log lmdb

EXECUTABLES     += test_muddb_export
TEST_TARGETS    += test_muddb_export
test_muddb_export_DIR := $(muddb-tool_DIR)
test_muddb_export_SRCS = test_muddb_export.c
test_muddb_export_LIBS = muddb_export database obj hashtable log lmdb
define test_muddb_export_TESTCMD
$(test_muddb_export_RUN)
endef
