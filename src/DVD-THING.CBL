       >>SOURCE FORMAT IS FIXED
       IDENTIFICATION DIVISION.
       PROGRAM-ID. dvd_thing. 
      ******************************************************************
      * TODO add desciption of program.
      ******************************************************************
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       SELECT F-LOGO-FILE ASSIGN TO "LOGO.TXT"
         ORGANIZATION IS LINE SEQUENTIAL.
      ******************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-EOF PIC X.
       01 WS-I-IDX PIC 999.
       01 WS-K-IDX PIC 999.
      * There is the function CBL_GET_SCR_SIZE to get the dimensions of
      * the terminal, but it makes the terminal misbehave for some 
      * reason.
       01 WS-TERMINAL.
          05 WS-T-WIDTH  PIC 999 VALUE 80.
          05 WS-T-HEIGHT PIC 999 VALUE 23.
       01 WS-FILLER-CHARACTER PIC X VALUE ".".
       01 WS-LOGO-IMAGE.
          05 WS-LI-LINE PIC X(31) USAGE NATIONAL OCCURS 8 TIMES.
       01 WS-LOGO.
          05 WS-L-WIDTH   PIC 999.
      * TODO See if this value can be pulled from line image table.
          05 WS-L-HEIGHT  PIC 999 VALUE 8.
          05 WS-L-X       PIC 999 VALUE 0.
          05 WS-L-DELTA-X PIC S9  VALUE 1.
          05 WS-L-Y       PIC 999 VALUE 0.
          05 WS-L-DELTA-Y PIC S9  VALUE 1.
      ******************************************************************
       PROCEDURE DIVISION.
       000-MAIN.
         PERFORM 001-LOAD-LOGO-FROM-FILE.
         PERFORM FOREVER
            PERFORM 001-UPDATE-TERMINAL
            PERFORM 001-MOVE-LOGO
            CALL "CBL_GC_NANOSLEEP" USING 500000000
         END-PERFORM.

       001-LOAD-LOGO-FROM-FILE.
         OPEN INPUT F-LOGO-FILE.
         MOVE 1 TO WS-I-IDX.
         PERFORM UNTIL (WS-EOF = "Y") OR (WS-I-IDX > WS-L-HEIGHT)
            READ F-LOGO-FILE INTO WS-LI-LINE(WS-I-IDX)
            AT END 
               MOVE 'Y' TO WS-EOF
            NOT AT END
               ADD 1 TO WS-I-IDX
         END-PERFORM.
         CLOSE F-LOGO-FILE.

         MOVE FUNCTION LENGTH(WS-LI-LINE(1)) TO WS-L-WIDTH.

       001-MOVE-LOGO.
         ADD WS-L-DELTA-X TO WS-L-X.
         IF (WS-L-X <= 0)
            OR (WS-L-X >= WS-T-WIDTH - WS-L-WIDTH) 
         THEN
            MULTIPLY -1 BY WS-L-DELTA-X
         END-IF.

         ADD WS-L-DELTA-Y TO WS-L-Y.
         IF (WS-L-Y <= 0)
            OR (WS-L-Y >= WS-T-HEIGHT - WS-L-HEIGHT)
         THEN
            MULTIPLY -1 BY WS-L-DELTA-Y
         END-IF.

       001-UPDATE-TERMINAL.
         CALL "SYSTEM" USING "clear".
         
         PERFORM VARYING WS-I-IDX FROM 1 BY 1 
                 UNTIL WS-I-IDX > WS-T-HEIGHT
            IF (WS-I-IDX > WS-L-Y) 
               AND (WS-I-IDX <= WS-L-Y + WS-L-HEIGHT)
            THEN
               PERFORM 010-PRINT-LOGO-LINE
            ELSE
               PERFORM VARYING WS-K-IDX FROM 1 BY 1 
                       UNTIL WS-K-IDX >= WS-T-WIDTH
                  DISPLAY WS-FILLER-CHARACTER WITH NO ADVANCING
               END-PERFORM
               DISPLAY "."
            END-IF
         END-PERFORM.

       010-PRINT-LOGO-LINE.
         PERFORM VARYING WS-K-IDX FROM 1 BY 1 UNTIL WS-K-IDX > WS-L-X
            DISPLAY WS-FILLER-CHARACTER WITH NO ADVANCING
         END-PERFORM.

         SUBTRACT WS-L-Y FROM WS-I-IDX GIVING WS-K-IDX.
         IF WS-L-X + WS-L-WIDTH < WS-T-WIDTH
            DISPLAY WS-LI-LINE(WS-K-IDX) WITH NO ADVANCING

            ADD WS-L-X, WS-L-WIDTH, 1 GIVING WS-K-IDX
            PERFORM UNTIL WS-K-IDX >= WS-T-WIDTH
               DISPLAY WS-FILLER-CHARACTER WITH NO ADVANCING
               ADD 1 TO WS-K-IDX
            END-PERFORM
            DISPLAY WS-FILLER-CHARACTER
         ELSE
            DISPLAY WS-LI-LINE(WS-K-IDX)
         END-IF.
