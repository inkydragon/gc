      READ(5,1)X
1     FORMAT(F10.5)
      A=X/2
2     B=(X/A+A)/2
      C=B-A
      IF(C.LT.0)C=-C
      IF(C.LT.10.E-6)GOTO 3
      A=B
      GOTO 2
3     WRITE(6,1)B
      STOP
      END