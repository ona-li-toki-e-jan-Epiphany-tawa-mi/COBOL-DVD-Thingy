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



COBC=cobc
COBFLAGS=${COBFLAGS:-'-O3 -Wall -Wextra -Werror'}

SOURCE_DIRECTORY=src
MAIN_SOURCE=$SOURCE_DIRECTORY/DVD-THING.CBL
SUB_SOURCES=$(find $SOURCE_DIRECTORY -type f \! -path $MAIN_SOURCE)

TO_OBJECTS () {
    # shellcheck disable=SC2068 # We want element splitting.
    basename -a $@ | sed 's|\.CBL$|.o|'
}

OUT=cobol-dvd-thingy



if [ 0 -eq $# ] || [ build = "$1" ]; then
    main_object=$(TO_OBJECTS "$MAIN_SOURCE")
    # shellcheck disable=SC2086 # We want word splitting.
    all_objects="$main_object $(TO_OBJECTS $SUB_SOURCES)"

    set -x
    for i in $SUB_SOURCES; do
        # shellcheck disable=SC2086 # We want word splitting.
        $COBC $COBFLAGS -cm "$i" -o "$(TO_OBJECTS "$i")" || exit 1
    done
    # shellcheck disable=SC2086 # We want word splitting.
    $COBC $COBFLAGS -cx "$MAIN_SOURCE" -o "$main_object" || exit 1
    # shellcheck disable=SC2086 # We want word splitting.
    $COBC $COBFLAGS -x $all_objects -o "$OUT"            || exit 1

elif [ clean = "$1" ]; then
    set -x
    rm -f "$OUT" ./*.o

else
    echo "$0: Error: Unknown build command '$1'" 1>&2
    exit 1
fi
