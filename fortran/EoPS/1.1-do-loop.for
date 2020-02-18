      program do_loop
C init var
      integer :: N = 4
      double precision :: V(4,4)

C bad way -------------------------
      DO 14 I=1,N
      DO 14 J=1,N
14    V(I,J)=(I/J)*(J/I)
C ---------------------------------
      write(*,*) "V ="
      write(*,"(4(F8.3))")V
c  V =
c    1.000   0.000   0.000   0.000
c    0.000   1.000   0.000   0.000
c    0.000   0.000   1.000   0.000
c    0.000   0.000   0.000   1.000
      end program do_loop