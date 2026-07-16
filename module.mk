# Boris MUD - top-level module.mk (modular-make)

ifdef DEBUG
PROJECT_CFLAGS   := -Wall -W -Werror=implicit -pthread
PROJECT_CPPFLAGS := -DNTEST
else
PROJECT_CFLAGS   := -Wall -W -Werror=implicit -O2 -g -pthread
PROJECT_CPPFLAGS := -DNTEST -DNDEBUG
endif
PROJECT_CPPFLAGS += \
	-DJSMN_STRICT \
	-Isrc \
	-Isrc/channel -Isrc/character -Isrc/crypt -Isrc/room -Isrc/cmd \
	-Isrc/worldclock -Isrc/web/server \
	-Isrc/thirdparty/jsmn \
	-Isrc/thirdparty/lmdb -Isrc/thirdparty/mth \
	-Isrc/thirdparty/tiny-aes -Isrc/thirdparty/smolvfs \
	-Isrc/scrypt -Isrc/log -Isrc/util -Isrc/help \
	-Isrc/iox -Isrc/net -Isrc/passwd \
	-Isrc/obj -Isrc/entity -Isrc/rpg -Isrc/database \
	-Isrc/coldfire -Isrc/machine
PROJECT_LDFLAGS  += -pthread
PROJECT_LDLIBS   += -pthread

SUBDIRS = src

# --- Install: stage binaries + web client into bin/ for packaging/deploy ------

STAGE_BINDIR     := bin
WEB_INSTALL_DIR  ?= $(STAGE_BINDIR)/www
WEB_ASSET_FOLDER ?= default

.PHONY: install
install: all
	@mkdir -p $(STAGE_BINDIR)
	cp $(boris_EXEC)      $(STAGE_BINDIR)/boris
	cp $(mkpass_EXEC)     $(STAGE_BINDIR)/mkpass
	cp $(muddb-tool_EXEC) $(STAGE_BINDIR)/muddb-tool
	@for b in boris mkpass muddb-tool; do \
		if [ -f "$(BINDIR)/$$b.debug" ]; then \
			cp "$(BINDIR)/$$b.debug" "$(STAGE_BINDIR)/$$b.debug"; \
		fi; \
	done
	@mkdir -p $(WEB_INSTALL_DIR)/assets
	rsync -a --exclude='assets' src/web/client/ $(WEB_INSTALL_DIR)/
	cp src/web/client/assets/layout.css $(WEB_INSTALL_DIR)/assets/ 2>/dev/null || true
	cp src/web/client/assets/system.css $(WEB_INSTALL_DIR)/assets/ 2>/dev/null || true
	@if [ -d src/web/client/assets/$(WEB_ASSET_FOLDER) ]; then \
		cp -r src/web/client/assets/$(WEB_ASSET_FOLDER)/* $(WEB_INSTALL_DIR)/assets/; \
	fi
	@if [ -d src/web/client/assets/fonts ]; then \
		cp -r src/web/client/assets/fonts $(WEB_INSTALL_DIR)/assets/; \
	fi
	@if [ -d src/web/client/assets/icon ]; then \
		cp -r src/web/client/assets/icon $(WEB_INSTALL_DIR)/assets/; \
	fi

# --- Release / deploy --------------------------------------------------------

RELEASE_ARCH ?= $(if $(findstring x86_64,$(TARGET_TRIPLET)),linux-x86_64,\
	$(if $(findstring aarch64,$(TARGET_TRIPLET)),linux-arm64,\
	$(if $(findstring arm,$(TARGET_TRIPLET)),linux-arm32,\
	linux-unknown)))

.PHONY: release deploy
release: install
	./scripts/build-release $(RELEASE_ARCH)

deploy: release
ifndef DEPLOY_DEST
	$(error DEPLOY_DEST is not set. Set it in .env or on the command line)
endif
	./scripts/deploy.sh $(DEPLOY_DEST)

# --- Smoke tests -------------------------------------------------------------

.PHONY: smoke smoke-cas smoke-valgrind smoke-web
smoke: install
	@src/tests/test_smoke.sh

smoke-cas: install
	@BORIS_BACKEND=cas src/tests/test_smoke.sh

smoke-valgrind: install
	@USE_VALGRIND=1 src/tests/test_smoke.sh

smoke-web: install
	@src/tests/test_web_smoke.sh

# --- tests alias for run-tests -----------------------------------------------

.PHONY: tests
tests: run-tests

# --- distclean ---------------------------------------------------------------

.PHONY: distclean
distclean: clean-all
	$(RM) -r $(STAGE_BINDIR) _build _out
