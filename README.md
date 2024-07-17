![screenshot](screenshots/screensaver.png)

View build status:

- I2P: [http://oytjumugnwsf4g72vemtamo72vfvgmp4lfsf6wmggcvba3qmcsta.b32.i2p/hydra/jobset/cobol-dvd-thingy/master/latest-eval](http://oytjumugnwsf4g72vemtamo72vfvgmp4lfsf6wmggcvba3qmcsta.b32.i2p/hydra/jobset/cobol-dvd-thingy/master/latest-eval)
- Tor: [http://4blcq4arxhbkc77tfrtmy4pptf55gjbhlj32rbfyskl672v2plsmjcyd.onion/hydra/jobset/cobol-dvd-thingy/master/latest-eval](http://4blcq4arxhbkc77tfrtmy4pptf55gjbhlj32rbfyskl672v2plsmjcyd.onion/hydra/jobset/cobol-dvd-thingy/master/latest-eval)

# COBOL DVD Thingy

This program is a terminal screensaver for Linux and similar systems that
displays a moving DVD logo similar to the ones you might see in a DVD player.

Why COBOL? I wanted to learn COBOL, because why not, and I had the idea to make
this with it.

## How to build

Dependencies:

- GnuCOBOL - [https://gnucobol.sourceforge.io](https://gnucobol.sourceforge.io)

There is a `flake.nix` you can use with `nix develop path:.` to generate a
devlopment environment

Then, run the following command in the project directory:

```
./build.sh
```

The executable will be named `cobol-dvd-thingy`.

## Installation

You can install it with Nix from the NUR
([https://github.com/nix-community/NUR](https://github.com/nix-community/NUR))
with the following attribute:

```nix
nur.repos.ona-li-toki-e-jan-Epiphany-tawa-mi.cobol-dvd-thingy
```
