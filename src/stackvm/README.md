# StackVM: an embedded virtual machine

(updated November 10, 2019)

## Introduction

StackVM is a 32-bit virtual machine based on the Quake 3 VM bytecode. No code
from that project was used. Only the VM byte code specification was used as a
reference. 

## Usage

There is no compatibility between binaries built for Q3 and this library. This
library does not include the run-time necessary to run Q3 modules. Instead this
library acts as a framework for constructing completely custom run-times.

See tests/demovm.c for an example of a minimal run-time. The essential steps are:

  1. Allocate a VM environment with the maximum number of syscalls in your run-time. vm_env_new()
  2. Register syscall callbacks. e.g. vm_env_register(env, -1, sys_trap_print);
  3. Create a VM instance that uses the run-time environment constructed above. vm_new()
  4. Load a VM program into the instance. vm_load(vm, "somefile.qvm")
  5. Start an entry point with vm_call() 
  6. Run your VM with vm_run_slice()
  7. repeat vm_run_slice() until your program request termination

## Compiling

  $ make

The stackdump.c is optional, it is only included to aid in debugging and sharing bug reports.

## Running the tests

Tests are found in tests/ and can be ran from the top-level directory with:

  $ make tests

You will need to have tools (lcc compiler and qvm assembler) installed to run
the tests. The source for the tools is at

  git://github.com/OrangeTide/stackvm-tools.git

The file extra/Makefile assumes they are installed in ../stackvm-tools relative
to the top-level directory.

## License

All public domain software in this package is marked as such. If for any reason
public domain does not work in your jurisdiction, then please apply the CC0 1.0
Universal license to this software. 

The CC0 1.0 Universal license is available at:

  https://creativecommons.org/publicdomain/zero/1.0/legalcode
