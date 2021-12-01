C COMPUTE SQURE ROOTS BY NEWTON'S METHOD
 10   READ(5,11) X
 11   FORMAT (F10.0)
      IF (X .GE. 0.0) GOTO 20
         WRITE(6,13) X
 13      FORMAT (' SQRT(', 1PE12.5, ') UNDEFINED')
         GOTO 10
 20   IF (X .GT. 0.0) GOTO 30
         B = 0.0
         GOTO 50
 30   B = 1.0
 40      A = B
         B = (X/A + A)/2.0
         IF (ABS((X/B)/B - 1.0) .GE. 1.0E-5) GOTO 40
 50   WRITE(6,51) X, B
 51   FORMAT(' SQRT(', 1PE12.5, ') = ', 1PE12.5)
      GOTO 10
      END