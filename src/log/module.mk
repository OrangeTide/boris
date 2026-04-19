LIBRARIES += log
log_DIR   := $(dir $(lastword $(MAKEFILE_LIST)))
log_SRCS   = log.c eventlog.c
