       >>SOURCE FORMAT IS FIXED
       IDENTIFICATION DIVISION.
       PROGRAM-ID. DVD-THING.
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
      ******************************************************************
      * A terminal program that runs a screensaver similar to the ones
      * you see on DVD players.
      ******************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-I-IDX PIC 999.
       01 WS-K-IDX PIC 999.
       01 WS-TERMINAL.
          05 WS-T-WIDTH  PIC 9999.
          05 WS-T-HEIGHT PIC 9999.
       01 WS-FILLER-CHARACTER PIC X VALUE " ".
       01 WS-LOGO-IMAGE.
          78 WS-LI-LENGTH VALUE 8.
          78 WS-LI-WIDTH  VALUE 31.
          05 WS-LI-LINE PIC X(WS-LI-WIDTH) OCCURS WS-LI-LENGTH TIMES.
       01 WS-LOGO.
          05 WS-L-X       PIC 999 VALUE 0.
          05 WS-L-DELTA-X PIC S9  VALUE 1.
          05 WS-L-Y       PIC 999 VALUE 0.
          05 WS-L-DELTA-Y PIC S9  VALUE 1.
      ******************************************************************
       PROCEDURE DIVISION.
       000-MAIN.
          PERFORM 001-GET-TERMINAL-SIZE.
      *   Needs to be 1 less than the actual terminal height to account
      *   for the input line.
          SUBTRACT 1 FROM WS-T-HEIGHT END-SUBTRACT.

          PERFORM 001-LOAD-LOGO.
          PERFORM FOREVER
             PERFORM 001-UPDATE-TERMINAL
             PERFORM 001-MOVE-LOGO
             CALL "CBL_GC_NANOSLEEP" USING 500000000 END-CALL
          END-PERFORM.

       001-GET-TERMINAL-SIZE.
      * TODO: add more ways to get terminal size.
          MOVE 80 TO WS-T-WIDTH.
          MOVE 24 TO WS-T-HEIGHT.


       001-LOAD-LOGO.
          MOVE "  /==========\   /============\" TO WS-LI-LINE(1).
          MOVE " /==/  /======\ /==/===/  /===|" TO WS-LI-LINE(2).
          MOVE " |==/ /====/\==v==//==/  /===/ " TO WS-LI-LINE(3).
          MOVE " /========/  \==/  /========/  " TO WS-LI-LINE(4).
          MOVE "          ___\=/___            " TO WS-LI-LINE(5).
          MOVE "/-----===================---\  " TO WS-LI-LINE(6).
          MOVE "======V===I====D====E===O====  " TO WS-LI-LINE(7).
          MOVE "\-----===================---/  " TO WS-LI-LINE(8).

       001-MOVE-LOGO.
          ADD WS-L-DELTA-X TO WS-L-X END-ADD.
          IF (WS-L-X <= 0) OR (WS-L-X >= WS-T-WIDTH - WS-LI-WIDTH)
             MULTIPLY -1 BY WS-L-DELTA-X END-MULTIPLY
          END-IF.

          ADD WS-L-DELTA-Y TO WS-L-Y END-ADD.
          IF (WS-L-Y <= 0) OR (WS-L-Y >= WS-T-HEIGHT - WS-LI-LENGTH)
             MULTIPLY -1 BY WS-L-DELTA-Y END-MULTIPLY
          END-IF.

       001-UPDATE-TERMINAL.
          CALL "CLEAR-TERMINAL" END-CALL.

          PERFORM VARYING WS-I-IDX FROM 1 BY 1
                  UNTIL WS-I-IDX > WS-T-HEIGHT
             IF (WS-I-IDX > WS-L-Y)
                AND (WS-I-IDX <= WS-L-Y + WS-LI-LENGTH)
             THEN
                PERFORM 005-PRINT-LOGO-LINE
             ELSE
      *      Prints the lines without the logo.
                PERFORM VARYING WS-K-IDX FROM 1 BY 1
                        UNTIL WS-K-IDX >= WS-T-WIDTH
                   DISPLAY WS-FILLER-CHARACTER WITH NO ADVANCING
                   END-DISPLAY
                END-PERFORM
                DISPLAY WS-FILLER-CHARACTER END-DISPLAY
             END-IF
          END-PERFORM.

       005-PRINT-LOGO-LINE.
      *   Prints filler up to logo.
          PERFORM VARYING WS-K-IDX FROM 1 BY 1 UNTIL WS-K-IDX > WS-L-X
             DISPLAY WS-FILLER-CHARACTER WITH NO ADVANCING END-DISPLAY
          END-PERFORM.

          SUBTRACT WS-L-Y FROM WS-I-IDX GIVING WS-K-IDX END-SUBTRACT.
          IF WS-L-X + WS-LI-WIDTH < WS-T-WIDTH
             DISPLAY WS-LI-LINE(WS-K-IDX) WITH NO ADVANCING END-DISPLAY

      *      Prints filler after logo.
             ADD WS-L-X, WS-LI-WIDTH, 1 GIVING WS-K-IDX END-ADD
             PERFORM UNTIL WS-K-IDX >= WS-T-WIDTH
                DISPLAY WS-FILLER-CHARACTER WITH NO ADVANCING
                END-DISPLAY
                ADD 1 TO WS-K-IDX END-ADD
             END-PERFORM
             DISPLAY WS-FILLER-CHARACTER END-DISPLAY
          ELSE
             DISPLAY WS-LI-LINE(WS-K-IDX) END-DISPLAY
          END-IF.
