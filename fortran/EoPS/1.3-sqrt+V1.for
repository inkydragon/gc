      READ(5,1)X
1     FORMAT(F10.5)
      A=X/2
2     B=(X/A+A)/2
C ---------------------------------------
C     C=B-A
C     IF(C.LT.0)C=-C
C     IF(C.LT.10.E-6)GOTO 3
      IF (ABS(B-A) .LT. 1.0E-5) GOTO 3
C ---------------------------------------
      A=B
      GOTO 2
3     WRITE(6,1)B
      STOP
      END