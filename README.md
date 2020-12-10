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

- NO FEATURES!

## Building

### Build requirements

- GNU Make 4.2.1 (or later)
- [libtelnet](https://github.com/seanmiddleditch/libtelnet)
- [libevent](https://libevent.org/)
- [libssh](https://www.libssh.org/)
- [libmicrohttpd](http://www.gnu.org/software/libmicrohttpd/)
- [LMDB](https://github.com/LMDB/lmdb)

#### Ubuntu / Debian Setup

```sh
sudo apt-get install libtelnet-dev libevent-dev libssh-dev libmicrohttpd-dev liblmdb-dev
```

### Check-out and Build from source

```sh
git clone git://github.com/OrangeTide/boris
cd boris
make
```

Build output is an executable (`boris`).

## Usage

### Configure

Edit configuration file (`boris.cfg`) with your preferred MUD port (`server.port`) and web port (`webserver.port`). And run the server:

### Starting for the first time

```sh
$ ./boris
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
Copyright (c) 2008-2020, Jon Mayo

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.

The views and conclusions contained in the software and documentation are
those of the authors and should not be interpreted as representing official
policies, either expressed or implied, of the Boris MUD project.
```

## Links & Citations

[1]: Gibson, William (1984). Neuromancer. p. 69
