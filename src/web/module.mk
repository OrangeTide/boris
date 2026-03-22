WEB_INSTALL_DIR ?= $(BINDIR)/www
WEB_ASSET_FOLDER ?= default

.PHONY: install
install: all
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
