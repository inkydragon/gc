%% Q1
clear
x_num=7;
fun = @(x) x(1)+x(2)+x(3)+x(4)+x(5)+x(6)+x(7);

x0 = 20.*ones(1,x_num); 
A = -[
    1 0 0 1 1 1 1; 
    1 1 0 0 1 1 1; 
    1 1 1 0 0 1 1;
    1 1 1 1 0 0 1;
    1 1 1 1 1 0 0;
    0 1 1 1 1 1 0;
    0 0 1 1 1 1 1
    ]; 
B = -[50; 50; 50; 50; 80; 90; 90]; 

[x, f] = fmincon(fun,x0,A,B);
i=1:x_num;
fprintf('Xn    x\n');
fprintf('x%d = %2.0f\n',[i;x]);
fprintf('\nf  =  %2.0f\n',f);
