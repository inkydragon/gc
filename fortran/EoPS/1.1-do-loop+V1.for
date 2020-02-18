      program do_loop
C init var
      integer :: N = 4
      double precision :: V(4,4)

C good way ------------------------
C MAKE V AN IDENTITY MATRIX
      DO 14 I = 1,N
         DO 12 J = 1,N
12          V(I,J) = 0.0
14       V(I,I) = 1.0
C ---------------------------------
      write(*,*) "V ="
      write(*,"(4(F8.3))")V
c  V =
c    1.000    0.000    0.000    0.000
c    0.000    1.000    0.000    0.000
c    0.000    0.000    1.000    0.000
c    0.000    0.000    0.000    1.000
      end program do_loop