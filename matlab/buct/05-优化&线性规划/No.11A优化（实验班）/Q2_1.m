%% Q2_1
clear
fun2 = @(x) -(power(x(1),2)+power(x(2),2)+power(x(3),2));

x0 = [sqrt(2)/2 -sqrt(2)/2 1]; 
xm = []; xM = []; 
A = []; B = []; 
Aeq = [1 1 1]; 
Beq = 1;

[x, f] = fmincon(fun2,x0,A,B,Aeq,Beq,xm,xM,@lp_con22);
i=[120 121 122];
fprintf('Xn    x\n');
fprintf('%c = %+5.3f\n',[i;x]);
fprintf('\nf  =  %g\n',-f);
