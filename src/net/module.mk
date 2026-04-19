LIBRARIES += net
net_DIR   := $(dir $(lastword $(MAKEFILE_LIST)))
net_SRCS   = net.c
net_LIBS   = iox

EXECUTABLES += test_net
test_net_DIR := $(net_DIR)
test_net_SRCS = test_net.c
test_net_LIBS = net iox
