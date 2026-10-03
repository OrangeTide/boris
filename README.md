# Boris MUD

A MUD code base in the style of the last millennium, written in the new millennium.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Build Requirements](#build-requirements)
- [Building](#building)
- [Releases](#releases)
- [Deploying](#deploying)
- [Local Configuration (.env)](#local-configuration-env)
- [Database Tools](#database-tools)
- [Running the Server](#running-the-server)
- [Development](#development)
- [Support](#support)
- [Contributing](#contributing)
- [License](#license)

## Introduction

> Cyberspace. A consensual hallucination experienced daily by billions of
> legitimate operators, in every nation, by children being taught mathematical
> concepts... A graphic representation of data abstracted from the banks of
> every computer in the human system. Unthinkable complexity. Lines of light
> ranged in the nonspace of the mind, clusters and constellations of data. Like
> city lights, receding.
> -- <cite>[William Gibson][1]</cite>

Boris MUD is a text-based virtual reality that allows multiple people to engage in roleplaying, adventuring, and story-telling.

## Features

- MTH (Mud Telopt Handler) - standardized handling of TELNET protocol.
- LMDB back-end database for objects and user accounts.
- Room navigation: look, go, enter, and direction aliases (north/n, south/s, etc.).
- SSE-based web client with output buffering and multipart framing.
- ***TODO*** Programmable objects -- objects can have RV32 programs (ELF binaries, compiled from kobold or C) attached that act on the game world through a small host-call interface. Replacing the earlier ColdFire sandbox, see [doc/mud-vm-design.md](doc/mud-vm-design.md).
- ***TODO*** ability to host multiple independent worlds from a single server.
- ***TODO*** On-Line Creation: interactive wizard provides menu-based building.

## Build Requirements

- GNU Make 4.2.1 (or later)
- GCC or Clang
- zlib development headers

Guest programs for the RV32 sandbox are built offline with the kobold and
skjegg toolchains, not by this build. The server itself needs no extra
toolchain to run pre-built program ELFs.

### Linux

Debian / Ubuntu:
```sh
sudo apt update
sudo apt install build-essential zlib1g-dev
```

## Building

### Check out from source

```sh
git clone --recurse-submodules https://github.com/OrangeTide/boris
cd boris
```

### Build

Build using all available CPU cores:

```sh
make -j$(nproc)
```

To use Clang instead of GCC:

```sh
make -j$(nproc) USE_CLANG=1
```

To specify a cross-compiler directly:

```sh
make -j$(nproc) CC=arm-linux-gnueabihf-gcc
```

Build output binaries are `boris`, `mkpass`, and `muddb-tool` under
`_out/<triplet>/bin/` (e.g. `_out/x86_64-linux-gnu/bin/`). Object files go to
`_build/<triplet>/`, so cross-compiled objects and binaries don't clobber
native ones. `make install` stages the binaries and web client into `bin/`
for packaging and deployment.

### Install Web Client

To install the web client (to `bin/www/` by default):

```sh
make install
```

### Cross-Compiling for Raspberry Pi

#### 64-bit (aarch64)

Enable the arm64 architecture and install the cross toolchain with libraries:

```sh
sudo dpkg --add-architecture arm64
sudo apt update
sudo apt install gcc-aarch64-linux-gnu zlib1g-dev:arm64
```

**Note:** On Ubuntu and derivatives, the default apt mirrors only carry amd64/i386
packages. arm64 and armhf packages are served from `ports.ubuntu.com`. If `apt update`
fails with 404 errors for arm64, you need to add a ports source and pin
your existing sources to amd64 only. Create
`/etc/apt/sources.list.d/arm64-cross.list`:

```
deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports noble main universe
deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports noble-updates main universe
```

Then add `[arch=amd64,i386]` to each `deb` line in your existing
`/etc/apt/sources.list` (or files under `sources.list.d/`) so they stop
trying to fetch arm64 from the wrong mirror. Then run `sudo apt update` again.

Build with the cross-compiler:

```sh
make -j$(nproc) CC=aarch64-linux-gnu-gcc
```

For a fully static binary (no runtime dependencies on the Pi):

```sh
make -j$(nproc) CC=aarch64-linux-gnu-gcc LDFLAGS="-static"
```

#### 32-bit (armhf)

Follow the same ports.ubuntu.com setup as above (substituting `[arch=armhf]`
for `[arch=arm64]`, or `[arch=arm64,armhf]` if you want both) if needed, then:

```sh
sudo dpkg --add-architecture armhf
sudo apt update
sudo apt install gcc-arm-linux-gnueabihf zlib1g-dev:armhf
```

```sh
make -j$(nproc) CC=arm-linux-gnueabihf-gcc
```

Copy `bin/boris`, `bin/mkpass`, `boris.cfg`, and the `data/` directory to the Raspberry Pi to run.

### Cleaning

```sh
make clean                 # Remove object files and dependency files
make distclean             # Remove objects, binaries, and installed web assets
```

### Releases

Build a release tarball containing stripped binaries, web client, sample
config, and game data. Pass all build flags in the same command -- `release`
chains through the full build so `CC`, `LDFLAGS`, and `RELEASE_ARCH` must
all be present:

```sh
make -j$(nproc) release                         # native x86-64
make -j$(nproc) release CC=aarch64-linux-gnu-gcc LDFLAGS="-static" RELEASE_ARCH=linux-arm64
make -j$(nproc) release CC=arm-linux-gnueabihf-gcc LDFLAGS="-static" RELEASE_ARCH=linux-arm32
```

Output is a file like `boris-0.7-linux-arm64.tar.xz` in the project root.

### Deploying

Deploy a release to a remote server via SSH. Include the same build flags
as you would for `make release`:

```sh
make -j$(nproc) deploy DEPLOY_DEST=jon@myserver.com:mud
make -j$(nproc) deploy CC=arm-linux-gnueabihf-gcc LDFLAGS="-static" RELEASE_ARCH=linux-arm32 DEPLOY_DEST=jon@myserver.com:mud
```

This builds a release tarball and uploads it to the remote host. The deploy
script uses versioned releases with symlinks:

```
~/mud/
  releases/boris-0.7-linux-arm64/   # each release unpacked here
  shared/boris.cfg                  # persistent config (survives upgrades)
  shared/data/chars/                # persistent game data
  shared/data/users/
  current -> releases/...           # symlink to active release
```

On first deploy, `boris.cfg` is copied to `shared/` for editing. Game data
directories (`chars/`, `users/`) are symlinked from each release into
`shared/` so they persist across upgrades.

You can also deploy directly without the Makefile:

```sh
./scripts/deploy.sh jon@myserver.com:mud [tarball]
```

### Local Configuration (.env)

Per-checkout settings go in a `.env` file (not committed to git). The
Makefile reads it automatically. Copy the example to get started:

```sh
cp doc/env.example .env
```

Available settings:

| Variable       | Description                                        | Example                   |
|----------------|----------------------------------------------------|---------------------------|
| `DEPLOY_DEST`  | Deploy target for `make deploy` (user@host[:dir])  | `jon@myserver.com:mud`    |
| `RELEASE_ARCH` | Override release architecture label                | `linux-arm32`             |
| `CC`           | C compiler (useful for cross-compilation)          | `arm-linux-gnueabihf-gcc` |
| `LDFLAGS`      | Linker flags                                       | `-static`                 |

## Database Tools

Boris stores game data (rooms, characters, users) in an LMDB database
(`data/muddb/`) by default. The `muddb-tool` utility exports and imports
this data as plain-text JSON files organized by domain. World objects can
optionally be moved to a content-addressed store instead, see
[Object Store Backends](#object-store-backends).

### Export

Dump the entire database to a directory tree:

```sh
./bin/muddb-tool export data/muddb dump/
```

This creates `dump/<domain>/<key>.json` for every object. To export a
single domain:

```sh
./bin/muddb-tool export data/muddb dump/ rooms
```

### Import

Load JSON files into the database:

```sh
./bin/muddb-tool import data/muddb dump/
```

To import only specific domains:

```sh
./bin/muddb-tool import data/muddb dump/ rooms chars
```

### Initializing a New MUD

A `sample/` directory ships with the source (and binary releases) containing
a starter world with a handful of connected rooms. To set up a fresh
database:

```sh
mkdir -p data/muddb
./bin/muddb-tool import data/muddb sample/
```

Then start the server normally with `./bin/boris`.

### File Layout

The export/import format is a flat directory hierarchy:

```
sample/
  rooms/
    town-square.json    # {"id":"town-square","name.short":"Town Square", ...}
    east-gates.json
    ...
```

Each `.json` file contains a single JSON object. The filename (minus `.json`)
is the database key.

### Object Store

All data, including world objects (the `objs` domain: rooms, exits,
programs), lives in the LMDB database at `data/muddb/`, described above.
LMDB is the only live backend.

A content-addressed depot format (smolvfs CAS) is also available, but only
as an offline snapshot and export target, not as a live store. Each commit
to a depot is an immutable snapshot, so a depot keeps a history of world
states, which makes it useful for backups and for diffing world versions.
Export a snapshot with:

```sh
./bin/muddb-tool to-cas data/muddb data/casdb
```

See Backup and Restore below.

### Backup and Restore

The server runs unattended on hobby hardware, so regular backups are
important. Two approaches:

**JSON export (portable, human-readable)**

```sh
./bin/muddb-tool export data/muddb backup/
```

This creates one `.json` file per record. The export can be inspected,
edited, diffed, or version-controlled. To restore from a JSON export, stop
the server, then:

```sh
rm -rf data/muddb
mkdir -p data/muddb
./bin/muddb-tool import data/muddb backup/
```

**LMDB file copy with `mdb_copy` (fast, compact)**

`mdb_copy` creates a consistent snapshot even while the server is running.
Install it from the system LMDB package (`apt install lmdb-utils` on
Debian/Ubuntu).

```sh
mdb_copy data/muddb /path/to/backup/muddb
```

Add `-c` to compact free pages during copy:

```sh
mdb_copy -c data/muddb /path/to/backup/muddb
```

To restore, stop the server and replace the database directory:

```sh
rm -rf data/muddb
cp -r /path/to/backup/muddb data/muddb
```

**CAS snapshot export (deduplicated history)**

For a backup that keeps a deduplicated history of world states, export the
object store into a CAS depot. Each export adds an immutable snapshot:

```sh
./bin/muddb-tool to-cas data/muddb /path/to/backup/casdb
```

Repeated exports to the same depot share unchanged objects, so the history
stays compact. Depot files are immutable once written, so copying a depot
elsewhere is always safe. This is an export format, not a live store: there
is no cas-to-muddb import yet, so keep a JSON or `mdb_copy` backup as the
restore path until one exists.

**Automated daily backup (cron)**

Back up with `muddb-tool`, keep 14 days of snapshots. Adjust `MUD_DIR` to
match your installation:

```
MUD_DIR=/home/mud/boris

# daily database export, 04:00, keep 14 days
0 4 * * * d=$MUD_DIR/backups/$(date +\%F); mkdir -p "$d" && $MUD_DIR/bin/muddb-tool export $MUD_DIR/data/muddb "$d" && find $MUD_DIR/backups -maxdepth 1 -mindepth 1 -mtime +14 -exec rm -rf {} +
```

Or with `mdb_copy` for a faster binary snapshot:

```
MUD_DIR=/home/mud/boris

# daily LMDB snapshot, 04:00, keep 14 days
0 4 * * * d=$MUD_DIR/backups/muddb-$(date +\%F); mkdir -p "$d" && mdb_copy -c $MUD_DIR/data/muddb "$d" && find $MUD_DIR/backups -maxdepth 1 -name 'muddb-*' -mtime +14 -exec rm -rf {} +
```

## Running the Server

### Configure

Edit configuration file (`boris.cfg`) with your preferred MUD port (`server.port`, default 4444) and web port (`webserver.port`, default 8080).

### Starting for the first time

Initialize the database with the sample world (optional but recommended):

```sh
mkdir -p data/muddb
./bin/muddb-tool import data/muddb sample/
```

Start the server:

```sh
./bin/boris
```

Login and create your account.

When running the server the web client will be hosted at `http://localhost:8080` (or your configured `webserver.port`).

### Stopping the server

Press Ctrl+C to shut down the server gracefully.

***TODO***: provide instructions on how to manually set administrator privileges on an account

### Troubleshooting

**`CRITICAL:telnetserver:telnet server error: could not bind socket (Address already in use)`**

Another process is already listening on the configured port. Find it with:

```sh
lsof -i tcp:4444
```

Either stop the other process or change `server.port` in `boris.cfg` to an unused port.

**`ERROR:muddb:mdb_env_open(data/muddb): No such file or directory`**

The LMDB database directory does not exist. Create it:

```sh
mkdir -p data/muddb
```

**Clients cannot connect (firewall blocking ports)**

If `ufw` is active on the server, open the telnet and web ports:

```sh
sudo ufw allow 4444/tcp
sudo ufw allow 8080/tcp
```

Replace the port numbers if you changed `server.port` or `webserver.port` in
`boris.cfg`. Check status with `sudo ufw status`.

## Programmable Objects

Objects can have programs attached to them. A program is an RV32 (RISC-V
32-bit) ELF binary, compiled from kobold or C, that runs in a bounded
emulator and acts on the game world through a small host-call interface.
Pre-built ELF binaries load automatically when the object enters the cache.

This subsystem is under active development. It replaces the earlier ColdFire
sandbox. See [doc/mud-vm-design.md](doc/mud-vm-design.md) for the design and
[doc/vm-migration-plan.md](doc/vm-migration-plan.md) for the (retired) record
of the migration. See [DEV.md](doc/DEV.md) for the architecture summary.

## Development

See [DEV.md](doc/DEV.md) for architecture, build system internals, code patterns, and contributor information.

## Support

Please [open an issue](https://github.com/OrangeTide/boris/issues/new) for support.

## Contributing

Please contribute using [Github Flow](https://docs.github.com/en/get-started/using-github/github-flow). Create a branch, add commits, and [open a pull request](https://github.com/OrangeTide/boris/compare/).

## Third-Party Libraries

Boris includes the following third-party libraries:

- [tiny-AES-c](https://github.com/kokke/tiny-AES-c) -- Small portable AES128/192/256 in C. Public domain (Unlicense). Used for scrypt password encryption.
- [LMDB](https://www.symas.com/lmdb) -- Lightning Memory-Mapped Database.
- [jsmn](https://github.com/zserge/jsmn) -- Minimalistic JSON parser.
- [MTH](https://tintin.mudhalla.net/protocols/mth/) -- MUD Telopt Handler.

## License

```
Copyright (c) 2008-2025, Jon Mayo
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies,
either expressed or implied, of the Boris MUD project.
```

[1]: https://en.wikipedia.org/wiki/Neuromancer "Gibson, William (1984). Neuromancer. p. 69"
