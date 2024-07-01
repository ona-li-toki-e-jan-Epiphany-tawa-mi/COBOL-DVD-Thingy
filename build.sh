#!/bin/sh

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
