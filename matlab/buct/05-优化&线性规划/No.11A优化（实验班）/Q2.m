%% Q2_1
fun = @(x) -(x(1)^2+x(2)^2+x(3)^2);
%lp_con = @(x)[[],x(1)^2+x(2)^2];

x0 = [sqrt(2)/2 -sqrt(2)/2  1]; 
xm = []; xM = []; 
A = []; B = []; 
Aeq = [1 1 1]; 
Beq = 1;

[x, f] = fmincon(fun,x0,A,B,Aeq,Beq,xm,xM,lp_con2);
i=['x' 'y' 'z'];
fprintf('Xn    x\n');
fprintf('%s = %2.0f\n',[i;x]);
fprintf('\nf  =  %2.0f\n',-f);
