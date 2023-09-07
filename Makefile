################################################################################
# MIT License                                                                  #
#                                                                              #
# Copyright (c) 2023 ona-li-toki-e-jan-Epiphany-tawa-mi                        #
#                                                                              #
# Permission is hereby granted, free of charge, to any person obtaining a copy #
# of this software and associated documentation files (the "Software"), to     #
# deal in the Software without restriction, including without limitation the   #
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or  #
# sell copies of the Software, and to permit persons to whom the Software is   #
# furnished to do so, subject to the following conditions:                     #
#                                                                              #
# The above copyright notice and this permission notice shall be included in   #
# all copies or substantial portions of the Software.                          #
#                                                                              #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR   #
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,     #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  #
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER       #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING      #
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS #
# IN THE SOFTWARE.                                                             #
################################################################################

COBC_STANDARD_ARGUMENTS := -Wall -Werror
SOURCE_DIRECTORY := src
MAIN_PROGRAM     := $(SOURCE_DIRECTORY)/DVD-THING.CBL
SUBPROGRAMS      := $(SOURCE_DIRECTORY)/PLATFORM/TERMINAL-SIZE.POSIX.CBL $(SOURCE_DIRECTORY)/PLATFORM/CLEAR-TERMINAL.POSIX.CBL

vpath %.CBL $(dir $(MAIN_PROGRAM) $(SUBPROGRAMS))
MAIN_PROGRAM_OBJECT_FILE := $(notdir $(MAIN_PROGRAM:.CBL=.o))
SUBPROGRAM_OBJECT_FILES  := $(notdir $(SUBPROGRAMS:.CBL=.o))

cobol-dvd-thing.out: $(MAIN_PROGRAM_OBJECT_FILE) $(SUBPROGRAM_OBJECT_FILES)
	cobc $(COBC_STANDARD_ARGUMENTS) -x -o $@ $^
$(MAIN_PROGRAM_OBJECT_FILE): %.o: %.CBL
	cobc $(COBC_STANDARD_ARGUMENTS) -cx -o $@ $<
$(SUBPROGRAM_OBJECT_FILES): %.o: %.CBL
	cobc $(COBC_STANDARD_ARGUMENTS) -cm -o $@ $<

.PHONY: clean
clean:
	rm *.out *.o
