![screenshot](screenshots/screensaver.png)

# COBOL DVD Thingy

This program is a terminal screensaver for Linux and similar systems that
displays a moving DVD logo similar to the ones you might see in a DVD player.

Why COBOL? I wanted to learn COBOL, because why not, and I had the idea to make
this with it.

## How to build

You will need the GnuCOBOL (https://gnucobol.sourceforge.io) compiler and make.
There is a `flake.nix` you can use with `nix develop path:.` to get them.

Then, run the following command in the project directory:

```
make
```

The executable will be named `cobol-dvd-thingy`.

## Installation

If you would like to install it, you do so with the following make command:

```
make install
```

You can also install it with Nix from the NUR
(https://github.com/nix-community/NUR) with the following attribute:

```nix
nur.repos.ona-li-toki-e-jan-Epiphany-tawa-mi.cobol-dvd-thingy
```
