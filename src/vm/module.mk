LIBRARIES += vm
vm_DIR  := $(dir $(lastword $(MAKEFILE_LIST)))
vm_SRCS  = vm.c
vm_LIBS  = skjrun

# The fs/ 9p server symbols the embedded emulator (skjrun) references. Kept in
# its own library that skjrun depends on (see the skjegg module.mk), so the
# modular-make topological order places it after skjrun on the link line, as a
# static link requires. The CAS-backed server replaces p9_stub.c here later.
LIBRARIES += p9stub
p9stub_DIR := $(vm_DIR)
p9stub_SRCS = p9_stub.c

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
