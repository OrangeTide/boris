LIBRARIES += mth
mth_DIR   := $(dir $(lastword $(MAKEFILE_LIST)))
mth_SRCS   = mth.c msdp.c telopt.c
mth_EXPORTED_LDLIBS = -lz
