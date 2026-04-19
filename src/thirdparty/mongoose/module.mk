LIBRARIES    += mongoose
mongoose_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
mongoose_SRCS = mongoose.c
