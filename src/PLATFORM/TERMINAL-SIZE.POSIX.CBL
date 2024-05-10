       >>SOURCE FORMAT IS FIXED
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TERMINAL-SIZE.
      ******************************************************************
      * MIT License
      *
      * Copyright (c) 2023-2024 ona-li-toki-e-jan-Epiphany-tawa-mi
      *
      * Permission is hereby granted, free of charge, to any person
      * obtaining a copy of this software and associated documentation
      * files (the "Software"), to deal in the Software without
      * restriction, including without limitation the rights to use,
      * copy, modify, merge, publish, distribute, sublicense, and/or
      * sell copies of the Software, and to permit persons to whom the
      * Software is furnished to do so, subject to the following
      * conditions:
      *
      * The above copyright notice and this permission notice shall be
      * included in all copies or substantial portions of the Software.
      *
      * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
      * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
      * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
      * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
      * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
      * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
      * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
      * OTHER DEALINGS IN THE SOFTWARE.
      **************************************************************************
      * Grabs the rows and columns of the terminal using tput.
      * POSIX only.
      *
      * Call convention:
      * CALL "TERMINAL-SIZE" USING TERMINAL END-CALL.
      *
      * This is used as an alternative to the function
      * CBL_GET_SCR_SIZE, which causes the terminal to misbehave for
      * some reason.
      *
      * Note: this has to temporarily create and destory a file called
      * ".COMMAND-OUTPUT.TXT" in the current working directory to read from the
      * system commands.
      ******************************************************************
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
          SELECT F-COMMAND-OUTPUT ASSIGN TO ".COMMAND-OUTPUT.TXT"
             ORGANIZATION IS LINE SEQUENTIAL.
      ******************************************************************
       DATA DIVISION.
       FILE SECTION.
       FD F-COMMAND-OUTPUT.
       01 FILLER PIC X(4).
       LINKAGE SECTION.
       01 L-TERMINAL.
          05 L-T-ROWS    PIC 9999.
          05 L-T-COLUMNS PIC 9999.
      ******************************************************************
       PROCEDURE DIVISION USING L-TERMINAL.
          CALL "SYSTEM" USING "tput lines > .COMMAND-OUTPUT.TXT && "-
                              "tput cols >> .COMMAND-OUTPUT.TXT"
          END-CALL.

          OPEN INPUT F-COMMAND-OUTPUT.
          READ F-COMMAND-OUTPUT INTO L-T-ROWS    END-READ.
          READ F-COMMAND-OUTPUT INTO L-T-COLUMNS END-READ.
          CLOSE F-COMMAND-OUTPUT.

          CALL "C$DELETE" USING ".COMMAND-OUTPUT.TXT", 0 END-CALL.

          EXIT PROGRAM.
