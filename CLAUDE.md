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
make smoke                 # Run smoke tests (requires expect)
make release               # Build + package release tarball
make deploy                # Build + package + deploy (needs DEPLOY_DEST)
```

Local configuration (deploy destination, etc.) goes in `.env` (see `env.example`). The Makefile reads it automatically via `-include .env`.

## Running

```sh
./bin/boris                # Start server (telnet on 4444, web on 8080)
```

Configuration: `boris.cfg` (server.port, webserver.port, channels, messages, new user settings).

## Architecture and Developer Guide

See [DEV.md](DEV.md) for architecture, subsystems, code patterns, and build system internals.

## Secure Programming Principles

See [SECURITY.md](SECURITY.md) for full details.

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
