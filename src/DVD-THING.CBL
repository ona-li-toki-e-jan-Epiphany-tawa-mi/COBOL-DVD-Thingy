       >>SOURCE FORMAT IS FIXED
       IDENTIFICATION DIVISION.
       PROGRAM-ID. DVD-THING.
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
      ******************************************************************
      * A terminal program that runs a screensaver similar to the ones
      * you see on DVD players.
      ******************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-I-IDX PIC 999.
       01 WS-K-IDX PIC 999.
       01 WS-TERMINAL.
          05 WS-T-HEIGHT PIC 999.
EP0923    05 WS-T-WIDTH  PIC 9999.
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
EP0923    CALL "TERMINAL-SIZE" USING WS-T-HEIGHT, WS-T-WIDTH.
      *   Needs to be 1 less than the actual terminal height to account
      *   for the input line.
          SUBTRACT 1 FROM WS-T-HEIGHT.

          PERFORM 001-LOAD-LOGO.
             PERFORM FOREVER
             PERFORM 001-UPDATE-TERMINAL
             PERFORM 001-MOVE-LOGO
             CALL "CBL_GC_NANOSLEEP" USING 500000000
          END-PERFORM.

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
          ADD WS-L-DELTA-X TO WS-L-X.
          IF (WS-L-X <= 0) OR (WS-L-X >= WS-T-WIDTH - WS-LI-WIDTH)
             MULTIPLY -1 BY WS-L-DELTA-X
          END-IF.

          ADD WS-L-DELTA-Y TO WS-L-Y.
          IF (WS-L-Y <= 0) OR (WS-L-Y >= WS-T-HEIGHT - WS-LI-LENGTH)
             MULTIPLY -1 BY WS-L-DELTA-Y
          END-IF.

       001-UPDATE-TERMINAL.
EP0923    CALL "CLEAR-TERMINAL".

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
                END-PERFORM
                DISPLAY WS-FILLER-CHARACTER
             END-IF
          END-PERFORM.

       005-PRINT-LOGO-LINE.
      *   Prints filler up to logo.
          PERFORM VARYING WS-K-IDX FROM 1 BY 1 UNTIL WS-K-IDX > WS-L-X
             DISPLAY WS-FILLER-CHARACTER WITH NO ADVANCING
          END-PERFORM.

          SUBTRACT WS-L-Y FROM WS-I-IDX GIVING WS-K-IDX.
          IF WS-L-X + WS-LI-WIDTH < WS-T-WIDTH
             DISPLAY WS-LI-LINE(WS-K-IDX) WITH NO ADVANCING

      *      Prints filler after logo.
             ADD WS-L-X, WS-LI-WIDTH, 1 GIVING WS-K-IDX
             PERFORM UNTIL WS-K-IDX >= WS-T-WIDTH
                DISPLAY WS-FILLER-CHARACTER WITH NO ADVANCING
                ADD 1 TO WS-K-IDX
             END-PERFORM
             DISPLAY WS-FILLER-CHARACTER
          ELSE
             DISPLAY WS-LI-LINE(WS-K-IDX)
          END-IF.
