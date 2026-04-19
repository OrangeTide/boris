LIBRARIES += help
help_DIR  := $(dir $(lastword $(MAKEFILE_LIST)))
help_SRCS  = help.c
