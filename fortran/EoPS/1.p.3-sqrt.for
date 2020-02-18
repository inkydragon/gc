C EXTERN FUNCTION
      REAL FUNCTION RELDIF(X, Y)
      RELDIF = ABS(X - Y) / AMAX1(ABS(X), ABS(Y))
      RETURN
      END

      PROGRAM MY_SQRT
C COMPUTE SQURE ROOTS BY NEWTON'S METHOD
 100  READ(5,110) X
 110     FORMAT(F10.0)
C
      IF (X .LT. 0.0) WRITE(6,120) X
 120     FORMAT(1X, 'SQRT(', 1PE12.4, ') UNDEFINED')
C
      IF (X .EQ. 0.0) WRITE(6,130) X, X
 130     FORMAT(1X, 'SQRT(', 1PE12.4, ') = ', 1PE12.4)
C
      IF (X .LE. 0.0) GOTO 100
      B = X/2.0
c  200  IF (ABS(X/B - B) .LT. 1.0E-5 * B) GOTO 300
 200  IF (RELDIF(X/B, B) .LT. 1.0E-5) GOTO 300
C -----------------------------------------------------
      B = (X/B + B) / 2.0
      GOTO 200
 300  WRITE(6,130) X, B
      GOTO 100
      END PROGRAM MY_SQRT