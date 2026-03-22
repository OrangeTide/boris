# src/tests/module.mk : smoke test target

.PHONY: smoke

smoke: $(BINDIR)/boris
	@src/tests/test_smoke.sh
