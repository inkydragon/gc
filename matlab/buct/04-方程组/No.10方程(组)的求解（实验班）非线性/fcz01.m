%% 牛顿法解方程组
function []=n

n=10;  tol = 1e-6; COND_NUM = 1e5;
x = [1, 1]';

i =1; u =[1,1]'; 
while(norm(u) > tol*norm(x)   )
    A = 2*[x(1), x(2); x(1),  -x(2)];
    f  = [4-x(1)^2-x(2)^2, 1-x(1)^2+x(2)^2]';
    if (cond(A) > COND_NUM)
        error ('matrix A is ill condition');  
        return
    else
         u = A\f;
     end
     x = x+u;
     i = i+1; 
     if(i>n) error ('n is full');
     end
 end
 
 i, vpa(x, 10)