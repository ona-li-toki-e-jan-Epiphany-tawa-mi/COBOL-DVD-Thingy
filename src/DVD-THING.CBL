       IDENTIFICATION DIVISION.
       PROGRAM-ID. DVD-THING.
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
          PERFORM FOREVER
             PERFORM 001-DISPLAY
             PERFORM 001-MOVE-LOGO
      *      0.5 seconds.
             CALL "CBL_GC_NANOSLEEP" USING 500000000 END-CALL
          END-PERFORM.

       001-DISPLAY.
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

       001-MOVE-LOGO.
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
