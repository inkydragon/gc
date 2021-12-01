%% Ex1
%  c(x) <=0
% ceq(x) =0
% A * x <=b
% Aeq * x=beq
% lb <= x <= ub
clear
x_num=5;
fun = @(x) (x(1)-1)^2+(x(2)-x(3))^2+(x(4)-x(5))^2;

x0 = ones(1,x_num); 
Aeq = [
    1 1 1  1  1; 
    0 0 1 -2 -2 
    ]; 
beq = [5;-3]; 

[x, f] = fmincon(fun,x0,[],[],Aeq,beq);
i=1:x_num;
fprintf('Xn    x\n');
fprintf('x%d = %2.0f\n',[i;x]);
fprintf('\nf  =  %2.0f\n',f);
