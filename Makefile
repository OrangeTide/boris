# -----------------------------------------------------------------------------
# CMake project wrapper Makefile ----------------------------------------------
# -----------------------------------------------------------------------------

SHELL := /bin/bash
RM    := rm -f
RMF   := rm -rf
MKDIR := mkdir -p
RMDIR := rmdir
CMAKE := cmake

# detect host build system
ifneq ($(MINGW_CHOST),)
CMAKE_OPTS := -G "MinGW Makefiles"
else
CMAKE_OPTS := -G "Unix Makefiles"
endif

CMAKE_OPTS += -DCMAKE_VERBOSE_MAKEFILE=ON

ifneq ($(USE_CLANG),)
CMAKE_OPTS += -D_CMAKE_TOOLCHAIN_PREFIX="llvm-"
CMAKE_OPTS += -DCMAKE_C_COMPILER="/usr/bin/clang"
else
# work-around for toolchains on some linux distros
# CMAKE_OPTS += -DCMAKE_AR="gcc-ar"
endif

.PHONY: all clean distclean install

all: ./build/Makefile
	@ $(MAKE) -C build

install:
	@ $(MAKE) -C build install

./build/Makefile:
	@  ($(MKDIR) build > /dev/null)
	@  (cd build > /dev/null 2>&1 && $(CMAKE) .. $(CMAKE_OPTS))

clean: ./build/Makefile
	@- $(MAKE) -C build clean || true

distclean:
	@  echo Removing build/
	@  ($(MKDIR) build > /dev/null)
	@- $(MAKE) --silent -C build clean > /dev/null 2>&1 || true
	@- $(RM) ./build/Makefile
	@- $(RMF) ./build/CMake*
	@- $(RM) ./build/cmake.*
	@- $(RM) ./build/*.cmake
	@- $(RM) ./build/*.txt
	@- $(RMF) ./build/test
	@- $(RMF) ./build/src
	@- $(RMF) ./build/include
	@- $(RMF) ./build/lib
	@  $(RMDIR) ./build

ifeq ($(findstring distclean,$(MAKECMDGOALS)),)
	$(MAKECMDGOALS): ./build/Makefile
	@ $(MAKE) -C build $(MAKECMDGOALS)
endif
