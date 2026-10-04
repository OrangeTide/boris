LIBRARIES += zone
zone_DIR   := $(dir $(lastword $(MAKEFILE_LIST)))
zone_SRCS   = zone.c
zone_LIBS   = obj log
zone_EXPORTED_CPPFLAGS = -I$(zone_DIR)

LIBRARIES += zone_builder
zone_builder_DIR   := $(zone_DIR)
zone_builder_SRCS   = zone_builder.c zone_ops.c
zone_builder_LIBS   = zone builder obj acs log
zone_builder_EXPORTED_CPPFLAGS = -I$(zone_builder_DIR)

EXECUTABLES     += test_zone
TEST_TARGETS    += test_zone
test_zone_DIR := $(zone_DIR)
test_zone_SRCS = test_zone.c
test_zone_LIBS = zone obj hashtable smolvfs database lmdb log
define test_zone_TESTCMD
$(test_zone_RUN)
endef

EXECUTABLES     += test_zone_builder
TEST_TARGETS    += test_zone_builder
test_zone_builder_DIR := $(zone_DIR)
test_zone_builder_SRCS = test_zone_builder.c
test_zone_builder_LIBS = zone_builder zone builder obj acs hashtable smolvfs database lmdb log
define test_zone_builder_TESTCMD
$(test_zone_builder_RUN)
endef
