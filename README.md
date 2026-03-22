# Boris MUD

A MUD code base in the style of the last millennium, written in the new millennium.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Build Requirements](#build-requirements)
- [Building](#building)
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
- ***WIP*** Support for Web-based client(s).
- ***TODO*** ability to host multiple independent worlds from a single server.
- ***TODO*** On-Line Creation: interactive wizard provides menu-based building.

## Build Requirements

- GNU Make 4.2.1 (or later)
- GCC or Clang
- zlib development headers
- OpenSSL development headers (for scrypt)

### Linux

Debian / Ubuntu:
```sh
sudo apt-get update
sudo apt-get install build-essential libssl-dev zlib1g-dev
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

Build output is `bin/boris` and `bin/mkpass`.

### Install Web Client

To install the web client (to `bin/www/` by default):

```sh
make install
```

### Cross-Compiling for Raspberry Pi

Install the cross-compilation toolchain:

```sh
sudo apt-get install gcc-arm-linux-gnueabihf
```

Build with the cross-compiler:

```sh
make -j$(nproc) CC=arm-linux-gnueabihf-gcc
```

Copy `bin/boris`, `boris.cfg`, and the `data/` directory to the Raspberry Pi to run.

### Cleaning

```sh
make clean                 # Remove object files and dependency files
make distclean             # Remove objects, binaries, and installed web assets
```

## Running the Server

### Configure

Edit configuration file (`boris.cfg`) with your preferred MUD port (`server.port`, default 4444) and web port (`webserver.port`, default 8080).

### Starting for the first time

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

## Development

To run tests:

***TODO***: add `make tests` to the build.

## Support

Please [open an issue](https://github.com/OrangeTide/boris/issues/new) for support.

## Contributing

Please contribute using [Github Flow](https://docs.github.com/en/get-started/using-github/github-flow). Create a branch, add commits, and [open a pull request](https://github.com/OrangeTide/boris/compare/).

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
