# MIT License
#
# Copyright (c) 2023-2024 ona-li-toki-e-jan-Epiphany-tawa-mi
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
#   nix build -f release.nix
# But you should probably use nix-shell + make instead.

# We use nixpkgs-unstable since the NUR does as well.
{ nixpkgs ? builtins.fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-unstable"
, system  ? builtins.currentSystem
}:

let pkgs = import nixpkgs {};
    src  = builtins.fetchGit ./.;
in
{
  build =
    let pkgs = import nixpkgs { inherit system; };
    in pkgs.releaseTools.nixBuild rec {
      name = "cobol-dvd-thingy";

      inherit src;

      # We have to use gnu-cobol.bin because gnu-cobol doesn't properly output
      # it's binary, I think.
      nativeBuildInputs = with pkgs; [ gnu-cobol.bin gmp ];

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp ${name} $out

        runHook postInstall
       '';
    };
}
