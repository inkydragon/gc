%% 牛顿法解方程组
function [i,res]=Newt_equ(f,df,x,n,tol)
COND_NUM = 1e5;

i =1; 
u =x; 
while(norm(u) > tol*norm(x) )
    if (cond(df(x)) > COND_NUM)
        error ('matrix A is ill condition');  
        return
    else
        u = df(x)\f(x);
    end
    
	x = x+u;
	i = i+1; 
    
	if(i>n) 
        error ('n is full');
	end
end
%res=vpa(x, 10);
res=x;