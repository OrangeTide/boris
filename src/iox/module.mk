LIBRARIES += iox
iox_DIR   := $(dir $(lastword $(MAKEFILE_LIST)))
iox_SRCS   = iox_loop.c iox_fd.c iox_signal.c iox_timer.c
