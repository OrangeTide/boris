EXECUTABLES    += muddb-tool
muddb-tool_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
muddb-tool_SRCS = muddb-tool.c
muddb-tool_LIBS = database obj log lmdb
