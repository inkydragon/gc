program do_loop
implicit none
integer,parameter :: N = 4
integer,dimension(N,N) :: v1, v2
integer i, j

! bad way ------------------------
do i = 1,N
    do j = 1,N
        v1(i,j) = (i/j)*(j/i)
    end do
end do
! --------------------------------
write(*,*)"v1:"
write(*,"(4(I4))")v1
!  v1:
!    1   0   0   0
!    0   1   0   0
!    0   0   1   0
!    0   0   0   1

! good way: NxN 单位矩阵 ----------
do i = 1,N
    do j = 1,N
        v2(i,j) = 0
    end do
    v2(i,i) = 1
end do
! --------------------------------
write(*,*)"v2:"
write(*,"(4(I4))")v2
!  v2:
!    1   0   0   0
!    0   1   0   0
!    0   0   1   0
!    0   0   0   1
end program do_loop