# COBOL DVD Thing

This program is a terminal screensaver that displays a moving DVD logo similar to the ones you might see in a DVD player.

Why?, and why COBOL? I wanted to learn COBOL, because why not, and I had the idea to make this with it.

## How to build

*Avalible on POSIX systems only.*

You will first need to install [cobc, the GnuCOBOL compiler,](https://gnucobol.sourceforge.io "GnuCOBOL SourceForge Main Page") installed on your system. 

Then, run the following command in the project directory:

```console
make
```

The executable will be named `cobol-dvd-thing.out`.

To remove the build files, run the following command in the project directory:

```console
make clean
```

## Installation

*Avalible on POSIX systems only.*

If you would like to run this program as command in the terminal, like as "cobol-dvd-thing", you will first either need to build it yourself from source, or download it from the [RELEASES](https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/COBOL-DVD-Thingy/releases "COBOL-DVD-Thingy RELEASES Tab on GitHub") tab (only precompiled for Linux.)

Then, run the following commands on the executable:

```
sudo cp cobol-dvd-thing.out /usr/local/bin/cobol-dvd-thing
sudo chown root:root /usr/local/bin/cobol-dvd-thing
sudo chmod u=w,a+rx /usr/local/bin/cobol-dvd-thing
```

