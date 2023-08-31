       >>SOURCE FORMAT IS FIXED
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TERMINAL-SIZE.
      ******************************************************************
      * Grabs the rows and columns of the terminal using tput. 
      * POSIX only.
      *
      * There is used as an alternative to the function
      * CBL_GET_SCR_SIZE, which causes the terminal to misbehave for
      * some reason.
      *
      * When calling, you will need to supply a record to store the 
      * terminal sizes. See L-TERMINAL-SIZE for what that will need to
      * contain.
      *
      * Note: this has to temporarily create and destory a file called 
      * "TPUT-OUTPUT.TXT" in the current working directory to read the
      * output from tput.
      * 
      * Author: ona li toki e jan Epiphany.
      ******************************************************************
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
         SELECT F-TPUT-OUTPUT ASSIGN TO "TPUT-OUTPUT.TXT"
            ORGANIZATION IS LINE SEQUENTIAL.
      ******************************************************************
       DATA DIVISION.
       LINKAGE SECTION.
       01 L-TERMINAL-SIZE.
         05 L-T-ROWS    PIC 999.
         05 L-T-COLUMNS PIC 999.
      ******************************************************************
       PROCEDURE DIVISION USING L-TERMINAL-SIZE.
         CALL "SYSTEM" USING "tput lines > TPUT-OUTPUT.TXT".
         OPEN INPUT F-TPUT-OUTPUT.
         READ F-TPUT-OUTPUT INTO L-T-ROWS.
         CLOSE F-TPUT-OUTPUT.

         CALL "SYSTEM" USING "tput cols > TPUT-OUTPUT.TXT".
         OPEN INPUT F-TPUT-OUTPUT.
         READ F-TPUT-OUTPUT INTO L-T-COLUMNS.
         CLOSE F-TPUT-OUTPUT.

         CALL "C$DELETE" USING "TPUT-OUTPUT.TXT", 0.

         EXIT PROGRAM.
