# Boris MUD

A MUD code base in the style of the last millennium, written in the new millennium.

[![Build Status](https://travis-ci.com/OrangeTide/boris.svg?branch=master)](https://travis-ci.com/OrangeTide/boris)

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Building](#building)
- [Usage](#usage)
- [Support](#support)
- [Contributing](#contributing)

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

- file-based database. Like NoSQL, but inferior in every way.

## Building

### Build requirements

- CMake 3.12 (or later)
- GNU Make 4.2.1 (or later)

#### Ubuntu / Debian Setup

```sh
sudo apt-get update
sudo apt-get install build-essential cmake libssl-dev zlib1g-dev
```

#### Alpine Linux

```sh
sudo apk update
sudo apk add build-base linux-headers make cmake git bash \
    zlib-dev openssl-libs-static openssl-dev openssl \
```

### Check-out and Build from source

```sh
git clone --recurse-submodules http://github.com/OrangeTide/boris
cd boris
make -j
```

Build output is an executable (`boris`).

Optionally to use clang instead of default CC, as above except provide `USE_CLANG=1` to make.
```
make -j USE_CLANG=1
```

For fast parallel builds, set `USE_NINJA=1` to use ninja instead of make.
```
make USE_NINJA=1
```

To install the client (to bin/www/ by default)
```
make install
```

When running the server the client will be hosted at `http://localhost:<webserver.port>`

## Usage

### Configure

Edit configuration file (`boris.cfg`) with your preferred MUD port (`server.port`) and web port (`webserver.port`). And run the server:

### Starting for the first time

```sh
$ ./bin/boris
```
Login and create your account.

*TODO: provide instructions on how to shut down server cleanly*

*TODO: provide instructions on how to manually set administrator privileges on an account*

## Support

Please [open an issue](https://github.com/OrangeTide/boris/issues/new) for support.

## Contributing

Please contribute using [Github Flow](https://guides.github.com/introduction/flow/). Create a branch, add commits, and [open a pull request](https://github.com/OrangeTide/boris/compare/).

## License

```
Copyright (c) 2008-2019, Jon Mayo
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

## Links & Citations

[1]: Gibson, William (1984). Neuromancer. p. 69
