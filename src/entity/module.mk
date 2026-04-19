LIBRARIES  += entity
entity_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
entity_SRCS = entity.c

EXECUTABLES     += test_entity
test_entity_DIR := $(entity_DIR)
test_entity_SRCS = test_entity.c
test_entity_LIBS = entity obj hashtable log
