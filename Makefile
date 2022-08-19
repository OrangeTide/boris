# -----------------------------------------------------------------------------
# CMake project wrapper Makefile ----------------------------------------------
# -----------------------------------------------------------------------------

SHELL := /bin/bash
RM    := rm -f
RMF   := rm -rf
MKDIR := mkdir -p
RMDIR := rmdir

.PHONY: all clean distclean

all: ./build/Makefile
	@ $(MAKE) -C build

./build/Makefile:
	@  ($(MKDIR) build > /dev/null)
	@  (cd build > /dev/null 2>&1 && cmake .. -DCMAKE_VERBOSE_MAKEFILE=TRUE)

clean: ./build/Makefile
	@- $(MAKE) -C build clean || true

distclean:
	@  echo Removing build/
	@  ($(MKDIR) build > /dev/null)
	@  (cd build > /dev/null 2>&1 && cmake .. > /dev/null 2>&1)
	@- $(MAKE) --silent -C build clean || true
	@- $(RM) ./build/Makefile
	@- $(RMF) ./build/CMake*
	@- $(RM) ./build/cmake.*
	@- $(RM) ./build/*.cmake
	@- $(RM) ./build/*.txt
	@- $(RMF) ./build/test
	@- $(RMF) ./build/src
	@- $(RMF) ./build/log
	@- $(RMF) ./build/thirdparty
	@- $(RM) ./build/passwd/cmake_install.cmake ./build/passwd/Makefile
	@- $(RMF) ./build/passwd/CMakeFiles/
	@- $(RMDIR) ./build/passwd
	@- $(RM) ./build/scrypt/cmake_install.cmake ./build/scrypt/Makefile
	@- $(RMF) ./build/scrypt/CMakeFiles/
	@- $(RMDIR) ./build/scrypt
	@  $(RMDIR) ./build

ifeq ($(findstring distclean,$(MAKECMDGOALS)),)
	$(MAKECMDGOALS): ./build/Makefile
	@ $(MAKE) -C build $(MAKECMDGOALS)
endif
