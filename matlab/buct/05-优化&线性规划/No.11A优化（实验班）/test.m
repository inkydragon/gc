%% Q1
fun = @(x) 2*(x(1)*x(3)+x(2)*x(3))+x(1)*x(2);


x0 = [1 1 1]; xm = [0;0;0]; xM = []; 
A =[]; B = []; Aeq = []; Beq = [];

[x, f] = fmincon(fun,x0,A,B,Aeq,Beq,xm,xM,@op_con1);
i=['x','y','z'];
fprintf('Xn    x\n');
fprintf('%c = %2.0f\n',[i;x]);
fprintf('\nf  =  %2.0f\n',f);
