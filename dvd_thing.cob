       >>SOURCE FORMAT IS FIXED
       IDENTIFICATION DIVISION.
       PROGRAM-ID. dvd_thing. 
      ******************************************************************
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
         SELECT F-LOGO-FILE ASSIGN TO "logo.txt"
            ORGANIZATION IS LINE SEQUENTIAL.
      ******************************************************************
       DATA DIVISION.
       FILE SECTION.
       FD F-LOGO-FILE.
       01 F-LOGO-IMAGE-LINE PIC N(45).
       WORKING-STORAGE SECTION.
       01 WS-LOGO-IMAGE.
          05 WS-LI-LINE PIC N(45) OCCURS 7 TIMES.
       01 WS-EOF PIC X.
       01 WS-LOGO.
          05 WS-L-WIDTH   PIC 99 VALUE 30.
          05 WS-L-HEIGHT  PIC 99 VALUE 7.
          05 WS-L-X       PIC 99 VALUE 0.
          05 WS-L-DELTA-X PIC S9 VALUE 1.
          05 WS-L-Y       PIC 99 VALUE 0.
          05 WS-L-DELTA-Y PIC S9 VALUE 1.
       01 WS-TERMINAL.
      *  TODO See if this can pull terminal size from OS.
          05 WS-TERMINAL-WIDTH  PIC S99 VALUE 80.
          05 WS-TERMINAL-HEIGHT PIC S99 VALUE 23.
       01 WS-FILLER-CHARACTER PIC X VALUE ".".
       01 WS-I PIC 99.
       01 WS-K PIC 99.
      ******************************************************************
       PROCEDURE DIVISION.
       000-MAIN.
         PERFORM 005-LOAD-LOGO-FROM-FILE.
         PERFORM FOREVER
            PERFORM 005-UPDATE-SCREEN
            PERFORM 005-MOVE-LOGO
            CALL "C$SLEEP" USING 1
         END-PERFORM.
         STOP RUN.

       005-LOAD-LOGO-FROM-FILE.
         OPEN INPUT F-LOGO-FILE.
         MOVE 1 TO WS-I.
         PERFORM UNTIL (WS-EOF = "Y") OR (WS-I > WS-L-HEIGHT)
            READ F-LOGO-FILE INTO F-LOGO-IMAGE-LINE 
            AT END 
               MOVE 'Y' TO WS-EOF
            NOT AT END
               MOVE F-LOGO-IMAGE-LINE TO WS-LI-LINE(WS-I)
               ADD 1 TO WS-I
         END-PERFORM.
         CLOSE F-LOGO-FILE.

       005-MOVE-LOGO.
         ADD WS-L-DELTA-X TO WS-L-X.
         IF (WS-L-X <= 0)
            OR (WS-L-X >= WS-TERMINAL-WIDTH - WS-L-WIDTH) 
         THEN
            MULTIPLY -1 BY WS-L-DELTA-X
         END-IF.

         ADD WS-L-DELTA-Y TO WS-L-Y.
         IF (WS-L-Y <= 0)
            OR (WS-L-Y >= WS-TERMINAL-HEIGHT - WS-L-HEIGHT)
         THEN
            MULTIPLY -1 BY WS-L-DELTA-Y
         END-IF.

       005-UPDATE-SCREEN.
         CALL "SYSTEM" USING "clear".
                  
         PERFORM VARYING WS-I FROM 1 BY 1 
                 UNTIL WS-I > WS-TERMINAL-HEIGHT
            IF (WS-I > WS-L-Y) 
               AND (WS-I <= WS-L-Y + WS-L-HEIGHT)
            THEN
               PERFORM 010-PRINT-LOGO-LINE
            ELSE
               PERFORM VARYING WS-K FROM 1 BY 1 
                       UNTIL WS-K >= WS-TERMINAL-WIDTH
                  DISPLAY WS-FILLER-CHARACTER WITH NO ADVANCING
               END-PERFORM
               DISPLAY "."
            END-IF
         END-PERFORM.

       010-PRINT-LOGO-LINE.
         PERFORM VARYING WS-K FROM 1 BY 1 UNTIL WS-K > WS-L-X
            DISPLAY WS-FILLER-CHARACTER WITH NO ADVANCING
         END-PERFORM.

         SUBTRACT WS-L-Y FROM WS-I GIVING WS-K.
         IF WS-L-X + WS-L-WIDTH < WS-TERMINAL-WIDTH
            DISPLAY WS-LI-LINE(WS-K) WITH NO ADVANCING

            ADD WS-L-X, WS-L-WIDTH, 1 GIVING WS-K
            PERFORM UNTIL WS-K >= WS-TERMINAL-WIDTH
               DISPLAY WS-FILLER-CHARACTER WITH NO ADVANCING
               ADD 1 TO WS-K
            END-PERFORM
            DISPLAY WS-FILLER-CHARACTER
         ELSE
            DISPLAY WS-LI-LINE(WS-K)
         END-IF.


      *      ELSE
      *         DISPLAY FILLER-CHARACTER WITH NO ADVANCING
      *      END-IF
      *   END-PERFORM.
      *   IF TERMINAL-WIDTH <= LOGO-X + LOGO-WIDTH 
      *      DISPLAY "A"
      *   ELSE
      *      DISPLAY FILLER-CHARACTER
      *   END-IF.
