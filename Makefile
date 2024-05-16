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



COBC     := cobc
COBFLAGS ?= -O3 -Wall -Wextra -Werror
srcdir   := src

MAIN_PROGRAM_SOURCE := $(srcdir)/DVD-THING.CBL
SUBPROGRAM_SOURCES  := $(addprefix $(srcdir)/,PLATFORM/TERMINAL-SIZE.POSIX.CBL PLATFORM/CLEAR-TERMINAL.POSIX.CBL)
vpath %.CBL $(dir $(MAIN_PROGRAM_SOURCE) $(SUBPROGRAM_SOURCES))
MAIN_PROGRAM_OBJECT := $(notdir $(MAIN_PROGRAM_SOURCE:.CBL=.o))
SUBPROGRAM_OBJECTS  := $(notdir $(SUBPROGRAM_SOURCES:.CBL=.o))

OUT ?= cobol-dvd-thingy

$(OUT): $(MAIN_PROGRAM_OBJECT) $(SUBPROGRAM_OBJECTS)
	$(COBC) $(COBFLAGS) -x -o $@ $^
$(MAIN_PROGRAM_OBJECT): %.o: %.CBL
	$(COBC) $(COBFLAGS) -cx -o $@ $<
$(SUBPROGRAM_OBJECTS): %.o: %.CBL
	$(COBC) $(COBFLAGS) -cm -o $@ $<



.PHONY: clean
clean:
	rm $(OUT) *.o



prefix      ?= /usr/local
exec_prefix ?= $(prefix)
bindir      ?= $(exec_prefix)/bin

INSTALL         ?= install
INSTALL_PROGRAM ?= $(INSTALL) -m 755

.PHONY: install
install: $(OUT)
	$(INSTALL_PROGRAM) -D $< $(DESTDIR)$(bindir)/$<

.PHONY: uninstall
uninstall:
	rm $(DESTDIR)$(bindir)/$(OUT)
