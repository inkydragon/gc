%% Ex2
%  c(x) <=0
% ceq(x) =0
% A * x <=b
% Aeq * x=beq
% lb <= x <= ub
clear
x_num=5;
fun = @(x) 2*x(1)+7*x(2)+4*x(3)+3*x(4)+5*x(5);

x0 = 100.*ones(1,x_num); 
A = -[
    3   20  10  6   18; 
    1   0.5 10  0.2 0.5;
    0.5 1   0.2 2   0.8
    ]; 
b = -[700;30;100]; 
xm = zeros(x_num);
[x, f] = fmincon(fun,x0,A,b,[],[],xm,[]);
i=1:x_num;
fprintf('Xn    x\n');
fprintf('x%d = %2.0f\n',[i;x]);
fprintf('\nf  =  %2.0f\n',f);