Compiling
=========

$ make

The stackdump.c is optional, it is only included to aid in debugging and sharing bug reports.

Running the tests
=================

$ make tests

You will need to have tools (lcc compiler and q3 assembler) installed to run the test.
Ideally git submodule can get them for you:

$ git submodule update

The source for the tools is at git://github.com/OrangeTide/stackvm-tools.git
