LIBRARIES  += passwd
passwd_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
passwd_SRCS = passwd.c

EXECUTABLES += mkpass
mkpass_DIR  := $(passwd_DIR)
mkpass_SRCS  = mkpass.c
mkpass_LIBS  = passwd scrypt tinyaes
