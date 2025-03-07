# This file is part of COBOL-DVD-Thingy.
#
# Copyright (c) 2024 ona-li-toki-e-jan-Epiphany-tawa-mi
#
# COBOL-DVD-Thingy is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# COBOL-DVD-Thingy is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# COBOL-DVD-Thingy. If not, see <https://www.gnu.org/licenses/>.

{
  description = "COBOL-DVD-Thingy development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      inherit (nixpkgs.lib) genAttrs systems;

      forSystems = f:
        genAttrs systems.flakeExposed
        (system: f { pkgs = import nixpkgs { inherit system; }; });
    in {
      devShells = forSystems ({ pkgs }: {
        default = with pkgs; mkShell { packages = [ gnu-cobol.bin gmp ]; };
      });
    };
}
