# MIT License
#
# Copyright (c) 2024 ona-li-toki-e-jan-Epiphany-tawa-mi
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.

# release.nix for telling Hydra CI how to build the project.
#
# You can use the following command to build this/these derivation(s):
#   nix-build release.nix -A <attribute>

# We use nixpkgs-unstable since the NUR does as well.
{ nixpkgs ? builtins.fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-unstable"
, src     ? ./.
, systems ? [ "x86_64-linux" "aarch64-linux" ]
}:

let pkgs = (import nixpkgs {});
    lib  = pkgs.lib;

    name = "cobol-dvd-thingy";
in
{
  # Builds the project for supported platforms.
  build = lib.genAttrs systems (system:
    let pkgs = import nixpkgs { inherit system; };
    in pkgs.stdenv.mkDerivation {
      localSystem = builtins.currentSystem;
      crossSystem = system;
      inherit name;

      inherit src;

      nativeBuildInputs = with pkgs; [ gnu-cobol.bin gmp ];

      buildPhase = ''
        runHook preBuild

        ./build.sh

        runHook postBuild
      '';

      installPhase = ''
          runHook preInstall

          mkdir -p $out/bin
          cp ${name} $out/bin

          runHook postInstall
        '';
    });

  # Makes tarballs of the source code.
  sourceTarball = pkgs.stdenv.mkDerivation {
    # No need to actually build the project.
    dontBuild   = true;
    dontInstall = true;

    inherit name;

    inherit src;

    doDist    = true;
    distPhase = ''
      runHook preDist

      mkdir -p $out/tarballs
      find -type f \! -path './.git' \! -path './.git/*' | sed 's|^\./||' | tar -T - -cavf $out/tarballs/${name}-source-dist.tar.xz

      runHook postDist
    '';

    postPhases = "finalPhase";
    finalPhase = ''
      mkdir -p $out/nix-support
      for i in $out/tarballs/*; do
          echo "file source-dist $i" >> $out/nix-support/hydra-build-products
      done
    '';
  };
}
