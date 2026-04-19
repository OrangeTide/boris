LIBRARIES   += tinyaes
tinyaes_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
tinyaes_SRCS = aes.c
