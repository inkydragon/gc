clear,
A = [ 1 2 3 0; 
      7 5 6 1; 
      0 2 4 1]

a1 = A(3,:)     %% the third row of A
a2 = A(:,2)     %% the second column of A
a3 = A(1:2,:)   
a4 = A(2:3, 2:4)

A(3,:)=[]    %% delete the 3-4rd culomn

b = [A(1:2,:); 
     ones(1,4)]