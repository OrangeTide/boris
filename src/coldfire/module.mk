LIBRARIES   += coldfire
coldfire_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
coldfire_SRCS = coldfire.c elf_loader.c
coldfire_EXPORTED_LDLIBS = -lm

EXECUTABLES      += test_coldfire
TEST_TARGETS     += test_coldfire
test_coldfire_DIR  := $(coldfire_DIR)
test_coldfire_SRCS  = test_coldfire.c
test_coldfire_LIBS  = coldfire
define test_coldfire_TESTCMD
$(test_coldfire_RUN)
endef
