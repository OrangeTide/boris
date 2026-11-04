LIBRARIES += vm
vm_DIR  := $(dir $(lastword $(MAKEFILE_LIST)))
vm_SRCS  = vm.c
vm_LIBS  = skjrun

EXECUTABLES += vm-run
vm-run_DIR  := $(vm_DIR)
vm-run_SRCS  = vm-run.c
vm-run_LIBS  = vm

EXECUTABLES  += test_vm
TEST_TARGETS += test_vm
test_vm_DIR := $(vm_DIR)
test_vm_SRCS = test_vm.c
test_vm_LIBS = vm
define test_vm_TESTCMD
$(test_vm_RUN)
endef
