# -----------------------------------------------------------------------------
# CMake project wrapper Makefile ----------------------------------------------
# -----------------------------------------------------------------------------

SHELL := /bin/bash
RM    := rm -f
RMF   := rm -rf
MKDIR := mkdir -p
RMDIR := rmdir
CMAKE := cmake
WEB_INSTALL_DIR ?= bin/www/

# detect host build system
ifneq ($(USE_NINJA),)
CMAKE_OPTS := -G "Ninja"
else ifneq ($(MINGW_CHOST),)
CMAKE_OPTS := -G "MinGW Makefiles"
else
CMAKE_OPTS := -G "Unix Makefiles"
endif

CMAKE_OPTS += -DCMAKE_VERBOSE_MAKEFILE=ON

ifneq ($(USE_CLANG),)
CC := $(shell which clang)
endif

CMAKE_OPTS += -DCMAKE_C_COMPILER="$(CC)"
CMAKE_OPTS += -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

.PHONY: all clean distclean

all: ./build/Makefile
	@ $(CMAKE) --build build

install: all
ifneq ($(USE_NINJA),)
	@ ninja -C build install
else
	@ $(MAKE) -C build install
endif

./build/Makefile:
	@  ($(MKDIR) build > /dev/null)
	@  (cd build > /dev/null 2>&1 && $(CMAKE) .. $(CMAKE_OPTS))

clean: ./build/Makefile
ifneq ($(USE_NINJA),)
	@- echo "Clean not supported"
else
	$(CMAKE) --build build -t clean
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
	@- $(RM)  ./build/compile_commands.json
	@- ${RMF} ./build/.cache
	@  $(RMDIR) ./build

ifeq ($(findstring distclean,$(MAKECMDGOALS)),)
	$(MAKECMDGOALS): ./build/Makefile
	ifneq ($(USE_NINJA),)
	@ ninja -C build $(MAKECMDGOALS)
	else
	@ $(MAKE) -C build $(MAKECMDGOALS)
	endif
endif
