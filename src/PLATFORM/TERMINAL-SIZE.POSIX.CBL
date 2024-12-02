       >>SOURCE FORMAT IS FIXED
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TERMINAL-SIZE.
      ******************************************************************
      * This file is part of COBOL-DVD-Thingy.
      *
      * Copyright (c) 2024 ona-li-toki-e-jan-Epiphany-tawa-mi
      *
      * COBOL-DVD-Thingy is free software: you can redistribute it and/or modify
      * it under the terms of the GNU General Public License as published by the
      * Free Software Foundation, either version 3 of the License, or (at your
      * option) any later version.
      *
      * COBOL-DVD-Thingy is distributed in the hope that it will be useful, but
      * WITHOUT ANY WARRANTY; without even the implied warranty of
      * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
      * Public License for more details.
      *
      * You should have received a copy of the GNU General Public License along
      * with COBOL-DVD-Thingy. If not, see <https://www.gnu.org/licenses/>.
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
