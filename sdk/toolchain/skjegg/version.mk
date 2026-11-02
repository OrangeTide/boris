# version.mk — the single source of truth for the Skjegg version.
#
# Bump this, then tag the release commit as v$(SKJ_VERSION).
# `make release-check` verifies the two agree.
#
# In-tree builds refine this with a git suffix (commit count, sha, -dirty).
# Vendored and tarball builds use it verbatim, so a consumer never sees
# their own project's tags reported as a Skjegg version.

SKJ_VERSION := 0.43.0
