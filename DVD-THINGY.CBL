       IDENTIFICATION DIVISION.
       PROGRAM-ID. DVD-THINGY.
      ******************************************************************
      * This file is part of COBOL-DVD-Thingy.
      *
      * Copyright (c) 2024 ona-li-toki-e-jan-Epiphany-tawa-mi
      *
      * COBOL-DVD-Thingy is free software: you can redistribute it
      * and/or modify it under the terms of the GNU General Public
      * License as published by the Free Software Foundation, either
      * version 3 of the License, or (at your option) any later version.
      *
      * COBOL-DVD-Thingy is distributed in the hope that it will be
      * useful, but WITHOUT ANY WARRANTY; without even the implied
      * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
      * PURPOSE. See the GNU General Public License for more details.
      *
      * You should have received a copy of the GNU General Public
      * License along with COBOL-DVD-Thingy. If not, see
      * <https://www.gnu.org/licenses/>.
      ******************************************************************
      * A terminal program that runs a screensaver similar to the ones
      * you see on DVD players.
      ******************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *   h - help.
      *   v - version.
      *   l - license.
       78 WS-GETOPT-SHORTOPTIONS VALUE "hvl".
       01 WS-GETOPT-LONGOPTIONS.
          05 WS-GETOPT-LONGOPTION OCCURS 3 TIMES.
             10 WS-GETOPT-LONGOPTION-NAME         PIC X(25).
             10 WS-GETOPT-LONGOPTION-HAS-VALUE    PIC 9.
             10 WS-GETOPT-LONGOPTION-VALPOINT     POINTER VALUE NULL.
             10 WS-GETOPT-LONGOPTION-RETURN       PIC X(4).
       01 WS-GETOPT-LONGOPTIONS-IDX PIC 99.
       01 WS-GETOPT-LONG-ONLY       PIC 9 VALUE 1.
       01 WS-GETOPT-RETURN-CHAR     PIC X(4).
       01 WS-GETOPT-OPT-VAL         PIC X(10).
      * ^--CBL_GC_GETOPT state.
       01 WS-SCREEN.
          05 WS-SCREEN-WIDTH  PIC 9999.
          05 WS-SCREEN-HEIGHT PIC 9999.
       01 WS-LOGO.
          78 WS-LOGO-WIDTH  VALUE 31.
          78 WS-LOGO-HEIGHT VALUE 8.
          05 WS-LOGO-LINES  VALUE "  /==========\   /============\" &
                                  " /==/  /======\ /==/===/  /===|" &
                                  " |==/ /====/\==v==//==/  /===/ " &
                                  " /========/  \==/  /========/  " &
                                  "          ___\=/___            " &
                                  "/-----===================---\  " &
                                  "======V===I====D====E===O====  " &
                                  "\-----===================---/  ".
             10 WS-LOGO-LINE OCCURS WS-LOGO-HEIGHT TIMES INDEXED
                BY WS-LOGO-LINE-IDX PIC X(WS-LOGO-WIDTH).
          05 WS-LOGO-X  PIC 9999 VALUE 1.
          05 WS-LOGO-DX PIC S9   VALUE 1.
          05 WS-LOGO-Y  PIC 9999 VALUE 1.
          05 WS-LOGO-DY PIC S9   VALUE 1.
      * Used to store which line number to display a logo line on.
       01 WS-DISPLAY-LINE PIC 9999.
      ******************************************************************
       PROCEDURE DIVISION.
       000-MAIN.
          PERFORM 001-GETOPT.
          PERFORM 001-RUN.
          STOP RUN RETURNING 0.

       001-GETOPT.
      *   0 means the option does not accept an argument.
          MOVE "help" TO WS-GETOPT-LONGOPTION-NAME(1).
          MOVE 0      TO WS-GETOPT-LONGOPTION-HAS-VALUE(1).
          MOVE 'h'    TO WS-GETOPT-LONGOPTION-RETURN(1).

          MOVE "version" TO WS-GETOPT-LONGOPTION-NAME(2).
          MOVE 0         TO WS-GETOPT-LONGOPTION-HAS-VALUE(2).
          MOVE 'v'       TO WS-GETOPT-LONGOPTION-RETURN(2).

          MOVE "license" TO WS-GETOPT-LONGOPTION-NAME(3).
          MOVE 0         TO WS-GETOPT-LONGOPTION-HAS-VALUE(3).
          MOVE 'l'       TO WS-GETOPT-LONGOPTION-RETURN(3).

          PERFORM WITH TEST AFTER UNTIL RETURN-CODE = -1
             CALL "CBL_GC_GETOPT" USING
                BY REFERENCE WS-GETOPT-SHORTOPTIONS
                   WS-GETOPT-LONGOPTIONS WS-GETOPT-LONGOPTIONS-IDX
                BY VALUE WS-GETOPT-LONG-ONLY
                BY REFERENCE WS-GETOPT-RETURN-CHAR WS-GETOPT-OPT-VAL
             END-CALL

             EVALUATE WS-GETOPT-RETURN-CHAR
      *      '?' means invalid option.
             WHEN = '?'
                DISPLAY "Try 'cobol-dvd-thingy -h' for more " &
                        "information"
                END-DISPLAY
                STOP RUN RETURNING 1
             WHEN = 'h'
                PERFORM 005-GETOPT-HELP
                STOP RUN RETURNING 0
             WHEN = 'v'
                DISPLAY "cobol-dvd-thingy 0.2.1" END-DISPLAY
                STOP RUN RETURNING 0
             WHEN = 'l'
                PERFORM 005-GETOPT-LICENSE
                STOP RUN RETURNING 0
             END-EVALUATE
          END-PERFORM.

       005-GETOPT-HELP.
          DISPLAY "Usage:"                          END-DISPLAY.
          DISPLAY "  cobol-dvd-thingy [options...]" END-DISPLAY
          DISPLAY SPACE                             END-DISPLAY.
          DISPLAY "A terminal program that runs a screensaver " &
                  "to the ones you see on DVD players."
          END-DISPLAY.
          DISPLAY SPACE                                   END-DISPLAY.
          DISPLAY "Options:"                              END-DISPLAY.
          DISPLAY "  -h, --help       display this help." END-DISPLAY.
          DISPLAY "  -v, --version    display version."   END-DISPLAY.
          DISPLAY "  -l, --license    display license."   END-DISPLAY.

       005-GETOPT-LICENSE.
          DISPLAY "Copyright (C) 2024 " &
                  "ona-li-toki-e-jan-Epiphany-tawa-mi."  END-DISPLAY.
          DISPLAY SPACE                                  END-DISPLAY.
          DISPLAY "This program is free software: you can "            &
                  "redistribute it and/or modify it under the terms "  &
                  "of the GNU General Public License as published by " &
                  "the Free Software Foundation, either version 3 of " &
                  "the License, or (at your option) any later version."
          END-DISPLAY.
          DISPLAY SPACE END-DISPLAY.
          DISPLAY "This program is distributed in the hope that it "   &
                  "will be useful, but WITHOUT ANY WARRANTY; without " &
                  "even the implied warranty of MERCHANTABILITY or "   &
                  "FITNESS FOR A PARTICULAR PURPOSE. See the GNU "     &
                  "General Public License for more details."
         END-DISPLAY.
         DISPLAY SPACE END-DISPLAY.
         DISPLAY "You should have received a copy of the GNU General " &
                 "Public License along with this program. If not, "    &
                 "see http://www.gnu.org/licenses/."
         END-DISPLAY.
         DISPLAY SPACE                END-DISPLAY.
         DISPLAY "Source (paltepuk):" END-DISPLAY.
         DISPLAY "https://paltepuk.xyz/cgit/COBOL-DVD-Thingy.git/about/"
         END-DISPLAY.
         DISPLAY "http://oytjumugnwsf4g72vemtamo72vfvgmp4lfsf6wmggcvb" &
                 "a3qmcsta.b32.i2p/cgit/COBOL-DVD-Thingy.git/about/"
         END-DISPLAY.
         DISPLAY "http://4blcq4arxhbkc77tfrtmy4pptf55gjbhlj32rbfyskl6" &
                 "72v2plsmjcyd.onion/cgit/COBOL-DVD-Thingy.git/about/"
         END-DISPLAY.
         DISPLAY SPACE              END-DISPLAY.
         DISPLAY "Source (GitHub):" END-DISPLAY.
         DISPLAY "https://github.com/ona-li-toki-e-jan-Epiphany-tawa-" &
                 "mi/COBOL-DVD-Thingy/"
         END-DISPLAY.

       001-RUN.
          PERFORM FOREVER
             PERFORM 005-RUN-DISPLAY
             PERFORM 005-RUN-MOVE-LOGO
      *      0.5 seconds.
             CALL "CBL_GC_NANOSLEEP" USING 500000000 END-CALL
          END-PERFORM.

       005-RUN-DISPLAY.
      *   Clear screen.
          DISPLAY SPACE BLANK SCREEN END-DISPLAY.

          ACCEPT WS-SCREEN-HEIGHT FROM LINES END-ACCEPT.
          ACCEPT WS-SCREEN-WIDTH FROM COLS END-ACCEPT.

          PERFORM VARYING WS-LOGO-LINE-IDX FROM 1
          UNTIL WS-LOGO-HEIGHT < WS-LOGO-LINE-IDX
             COMPUTE WS-DISPLAY-LINE = WS-LOGO-Y + WS-LOGO-LINE-IDX - 1
                END-COMPUTE
             DISPLAY WS-LOGO-LINE(WS-LOGO-LINE-IDX) AT
                LINE WS-DISPLAY-LINE COL WS-LOGO-X END-DISPLAY
          END-PERFORM.

       005-RUN-MOVE-LOGO.
          ADD WS-LOGO-DX TO WS-LOGO-X END-ADD.
          IF WS-LOGO-X < 1 THEN
             MOVE 2 TO WS-LOGO-X
             MOVE 1 TO WS-LOGO-DX
          ELSE IF WS-LOGO-X > WS-SCREEN-WIDTH - WS-LOGO-WIDTH THEN
             SUBTRACT 1 WS-LOGO-WIDTH FROM WS-SCREEN-WIDTH
                GIVING WS-LOGO-X END-SUBTRACT
             MOVE -1 TO WS-LOGO-DX
          END-IF END-IF.

          ADD WS-LOGO-DY TO WS-LOGO-Y END-ADD.
          IF WS-LOGO-Y < 1 THEN
             MOVE 2 TO WS-LOGO-Y
             MOVE 1 TO WS-LOGO-DY
          ELSE IF WS-LOGO-Y > WS-SCREEN-HEIGHT - WS-LOGO-HEIGHT THEN
             SUBTRACT 1 WS-LOGO-HEIGHT FROM WS-SCREEN-HEIGHT
                GIVING WS-LOGO-Y END-SUBTRACT
             MOVE -1 TO WS-LOGO-DY
          END-IF END-IF.
