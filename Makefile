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
else ifneq ($(USE_NINJA),)
CMAKE_OPTS := -G "Ninja"
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
ifneq ($(USE_NINJA),)
	@ ninja -C build
else
	@ $(MAKE) -C build
endif

install:
	@ $(MAKE) -C build install

./build/Makefile:
	@  ($(MKDIR) build > /dev/null)
	@  (cd build > /dev/null 2>&1 && $(CMAKE) .. $(CMAKE_OPTS))

clean: ./build/Makefile
ifneq ($(USE_NINJA),)
	@- echo "Clean not supported"
else
	@- $(MAKE) -C build clean || true
endif

distclean:
	@  echo Removing build/
	@  ($(MKDIR) build > /dev/null)
	@- $(MAKE) --silent -C build clean > /dev/null 2>&1 || true
	@- $(RM) ./build/Makefile
	@- $(RM) ./build/.ninja*
	@- $(RM) ./build/build.ninja
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
	ifneq ($(USE_NINJA),)
	@ ninja -C build $(MAKECMDGOALS)
	else
	@ $(MAKE) -C build $(MAKECMDGOALS)
	endif
endif
