       >>SOURCE FORMAT IS FIXED
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TERMINAL-SIZE.
EP0923******************************************************************
EP0923* MIT License
EP0923*
EP0923* Copyright (c) 2023 ona-li-toki-e-jan-Epiphany-tawa-mi
EP0923*
EP0923* Permission is hereby granted, free of charge, to any person
EP0923* obtaining a copy of this software and associated documentation
EP0923* files (the "Software"), to deal in the Software without
EP0923* restriction, including without limitation the rights to use,
EP0923* copy, modify, merge, publish, distribute, sublicense, and/or
EP0923* sell copies of the Software, and to permit persons to whom the
EP0923* Software is furnished to do so, subject to the following
EP0923* conditions:
EP0923*
EP0923* The above copyright notice and this permission notice shall be
EP0923* included in all copies or substantial portions of the Software.
EP0923*
EP0923* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EP0923* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
EP0923* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
EP0923* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
EP0923* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
EP0923* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
EP0923* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
EP0923* OTHER DEALINGS IN THE SOFTWARE.
      **************************************************************************
EP0923* Grabs the rows and columns of the terminal using tput.
EP0923* POSIX only.
      *
EP0923* Call convention:
EP0923* CALL "TERMINAL-SIZE" USING TERMINAL-ROWS, TERMINAL-COLUMNS.
      *
EP0923* This is used as an alternative to the function
      * CBL_GET_SCR_SIZE, which causes the terminal to misbehave for
      * some reason.
      *
      * Note: this has to temporarily create and destory a file called
EP0923* ".COMMAND-OUTPUT.TXT" in the current working directory to read from the
EP0923* system commands.
      ******************************************************************
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
EP0923    SELECT F-COMMAND-OUTPUT ASSIGN TO ".COMMAND-OUTPUT.TXT"
             ORGANIZATION IS LINE SEQUENTIAL.
      ******************************************************************
       DATA DIVISION.
       LINKAGE SECTION.
EP0923 01 L-TERMINAL-ROWS    PIC 999.
EP0923 01 L-TERMINAL-COLUMNS PIC 9999.
      ******************************************************************
EP0923 PROCEDURE DIVISION USING L-TERMINAL-ROWS, L-TERMINAL-COLUMNS.
EP0923    CALL "SYSTEM" USING "tput lines > .COMMAND-OUTPUT.TXT".
EP0923    CALL "SYSTEM" USING "tput cols >> .COMMAND-OUTPUT.TXT".

EP0923    OPEN INPUT F-COMMAND-OUTPUT.
EP0923    READ F-COMMAND-OUTPUT INTO L-TERMINAL-ROWS.
EP0923    READ F-COMMAND-OUTPUT INTO L-TERMINAL-COLUMNS.
EP0923    CLOSE F-COMMAND-OUTPUT.

EP0923    CALL "C$DELETE" USING ".COMMAND-OUTPUT.TXT", 0.

          EXIT PROGRAM.
