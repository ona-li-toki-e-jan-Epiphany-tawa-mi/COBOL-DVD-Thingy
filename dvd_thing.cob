       >>SOURCE FORMAT IS FIXED
       IDENTIFICATION DIVISION.
       PROGRAM-ID. dvd_thing. 
      ******************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 TERMINAL.
      *  TODO See if this can pull terminal size from OS.
         05 TERMINAL_WIDTH  PIC S99 VALUE 80.
         05 TERMINAL_HEIGHT PIC S99 VALUE 23.
       01 FILLER_CHARACTER PIC X VALUE ".".
       01 LOGO.
         05 LOGO_WIDTH   PIC 99 VALUE 16.
         05 LOGO_HEIGHT  PIC 99 VALUE 7.
         05 LOGO_X       PIC 99 VALUE 0.
         05 LOGO_DELTA_X PIC S9 VALUE 1.
         05 LOGO_Y       PIC 99 VALUE 0.
         05 LOGO_DELTA_Y PIC S9 VALUE 1.
      *  05 LOGO_TEXT    PIC X(16) OCCURS 7 TIMES.
       01 I PIC 99.
       01 K PIC 99.
      ******************************************************************
       PROCEDURE DIVISION.
       MAIN-LOOP.
      *  MOVE "⣿⣿⣿⣿⣿⣿⠀⠀⢀⣿⣿⣿⣿⣿⣦⡀" TO LOGO_TEXT(1).
      *  MOVE "⣿⣿⠀⠀⢹⣿⣿⣇⠀⣿⣿⣽⣿⠀⢹⣿" TO LOGO_TEXT(2).
      *  MOVE "⣿⣿⠀⢀⣾⣿⢹⣿⣶⡿⠋⣿⣿⠀⣼⣿" TO LOGO_TEXT(3).
      *  MOVE "⣿⣿⣿⣿⠟⠋⠀⣿⣿⠀⠀⣿⣿⣿⠟⠋" TO LOGO_TEXT(4).
      *  MOVE "⠀⠀⠀⠀⠀⠀⣀⣟⣁⣀⡀⠀⠀⠀⠀⠀" TO LOGO_TEXT(5).
      *  MOVE "⣶⣾⣿⣻⣻⣿⡟⢻⣿⣛⣿⣛⣛⣿⣦⣄" TO LOGO_TEXT(6).
      *  MOVE "⠻⠿⠿⠷⣿⣿⣧⣼⣿⣭⣿⣬⡭⠿⠛⠉" TO LOGO_TEXT(7).

         PERFORM FOREVER
            PERFORM UPDATE-SCREEN
            PERFORM MOVE-LOGO
            CALL "C$SLEEP" USING 1
         END-PERFORM.
         STOP RUN.



       MOVE-LOGO.
         ADD LOGO_DELTA_X TO LOGO_X.
         IF (LOGO_X <= 0) OR (LOGO_X >= TERMINAL_WIDTH - LOGO_WIDTH)
            MULTIPLY -1 BY LOGO_DELTA_X
         END-IF.

         ADD LOGO_DELTA_Y TO LOGO_Y.
         IF (LOGO_Y <= 0) OR (LOGO_Y >= TERMINAL_HEIGHT - LOGO_HEIGHT)
            MULTIPLY -1 BY LOGO_DELTA_Y
         END-IF.


       
       UPDATE-SCREEN.
         CALL "SYSTEM" USING "clear".
                  
         PERFORM VARYING I FROM 1 BY 1 UNTIL I > TERMINAL_HEIGHT
            IF (I > LOGO_Y) AND (I <= LOGO_Y + LOGO_HEIGHT)
               PERFORM PRINT-LOGO-LINE
            ELSE
               PERFORM VARYING K FROM 1 BY 1 UNTIL K >= TERMINAL_WIDTH
                  DISPLAY FILLER_CHARACTER WITH NO ADVANCING
               END-PERFORM
               DISPLAY "."
            END-IF
         END-PERFORM.

       PRINT-LOGO-LINE.
         PERFORM VARYING K FROM 1 BY 1 UNTIL K >= TERMINAL_WIDTH
            IF (K > LOGO_X) AND (K <= LOGO_X + LOGO_WIDTH)
               DISPLAY "A" WITH NO ADVANCING
            ELSE
               DISPLAY FILLER_CHARACTER WITH NO ADVANCING
            END-IF
         END-PERFORM.
         IF TERMINAL_WIDTH <= LOGO_X + LOGO_WIDTH 
            DISPLAY "A"
         ELSE
            DISPLAY FILLER_CHARACTER
         END-IF.
