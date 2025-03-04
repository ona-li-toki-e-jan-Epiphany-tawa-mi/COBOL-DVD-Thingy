![screenshot](screenshots/screensaver.png)

# COBOL DVD Thingy

This program is a terminal screensaver for Linux and similar systems that
displays a moving DVD logo similar to the ones you might see in a DVD player.

## How to build

Dependencies:

- GnuCOBOL - [https://gnucobol.sourceforge.io](https://gnucobol.sourceforge.io)

There is a `flake.nix` you can use with `nix develop` to generate a devlopment
environment

Then, run one of the following commands in the project directory:

```sh
./build.sh

# Build with optimizations
EXTRA_COBFLAGS='-O3' ./build.sh
```

The executable will be named `cobol-dvd-thingy`.

## Installation

You can install it with Nix from my personal package repository
[https://paltepuk.xyz/cgit/epitaphpkgs.git/about](https://paltepuk.xyz/cgit/epitaphpkgs.git/about).
