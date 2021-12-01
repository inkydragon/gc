%% Q2_2
clear
fun3 = @(x)x(1)*x(2)*x(3);
%lp_con = @(x)[[],x(1)^2+x(2)^2];

x0 = [3 6 3]; 
xm = [0;0;0]; xM = []; 
A = []; B = []; 
Aeq = []; 
Beq = [];

[x, f] = fmincon(fun3,x0,A,B,Aeq,Beq,xm,xM,@lp_con22);

i=[120 121 122];
fprintf('Xn  x\n');
fprintf('%c = %1.0f\n',[i;x]);
fprintf('\nf  =  %g\n',f);
