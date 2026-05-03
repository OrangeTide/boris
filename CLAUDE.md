# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

```sh
make -j                    # Build (parallel, default GCC)
make -j USE_CLANG=1        # Build with Clang
make install               # Build and install web client to bin/www/
make clean                 # Remove build objects
make distclean             # Remove all build artifacts including binaries
```

Build requires GNU Make 4.2.1+, GCC or Clang. On Debian/Ubuntu: `build-essential zlib1g-dev`.

Output binaries: `bin/boris`, `bin/mkpass`, `bin/muddb-tool`.

```sh
make tests                 # Run unit tests (obj, muddb, hashtable)
make tests-valgrind        # Run unit tests under valgrind (leak check)
make smoke                 # Run smoke tests (requires expect)
make release               # Build + package release tarball
make deploy                # Build + package + deploy (needs DEPLOY_DEST)
```

Local configuration (deploy destination, etc.) goes in `.env` (see `doc/env.example`). The Makefile reads it automatically via `-include .env`.

## Running

```sh
./bin/boris                # Start server (telnet on 4444, web on 8080)
```

Configuration: `boris.cfg` (server.port, webserver.port, channels, messages, new user settings).

## Architecture and Developer Guide

See [DEV.md](doc/DEV.md) for architecture, subsystems, code patterns, and build system internals.

## Kanban Board

Work items live in `kanban/` as one markdown file per card with YAML frontmatter (`title`, `status`). Status values: `backlog`, `active`, `done`.

```sh
grep -l 'status: backlog' kanban/*.md | sed 's|kanban/||;s|\.md||'   # list backlog cards
grep -l 'status: active' kanban/*.md | sed 's|kanban/||;s|\.md||'    # list active cards
```

When starting work on a card, set `status: active`. When done, set `status: done` and check all task boxes. Commits that complete a card should also update the card's status.

### GitLab Sync

Each card has a `gitlab-sync` frontmatter field linking it to a GitLab work item:

- `gitlab-sync: OrangeTide/boris#123` -- linked to existing issue
- `gitlab-sync:` (empty) -- CI will create a new GitLab issue and populate the ref
- `gitlab-sync: none` -- explicitly opted out of sync

Sync is **one-way, status-only** (card -> GitLab). Card contents are not synced to or from GitLab issue descriptions. When a card's status changes to `done`, CI closes the GitLab issue. When it changes to `active` or `backlog`, CI reopens it.

The sync runs via `scripts/kanban-sync.sh` in the `sync:kanban` CI job, triggered only on pushes to the default branch that modify `kanban/*.md`. New issues created by CI are committed back with `[skip ci]` to avoid re-triggering the pipeline.

## Secure Programming Principles

See [SECURITY.md](doc/SECURITY.md) for full details.

- Never trust external input.
- Always use parameterized queries and records, not string concatenation.
- Apply the principle of least privilege.
- Never store passwords in plain text; use password hashing (scrypt).
- Protect sensitive data in transit and at rest.
- Never hardcode secrets -- use the dotenv system.
- Avoid information leakage in error messages.
- Sanitize output to prevent XSS (embedded web server).
- Keep dependencies secure and monitored.
- Log and monitor security events.
