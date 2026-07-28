# src/iox/module.mk -- libiox, vendored. See VENDORED.md for the version.
LIBRARIES += iox
iox_DIR   := $(dir $(lastword $(MAKEFILE_LIST)))
iox_SRCS   = iox_loop.c iox_fd.c iox_signal.c iox_timer.c iox_plat.c
