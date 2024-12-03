#!/bin/sh

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

# Error on unset variables.
set -u



COBFLAGS="${COBFLAGS:--Wall -Wextra}"
EXTRA_COBFLAGS="${EXTRA_COBFLAGS:-}"
ALL_COBFLAGS="$COBFLAGS $EXTRA_COBFLAGS"

set -x
cobc $ALL_COBFLAGS -x -o cobol-dvd-thingy DVD-THINGY.CBL
