%% Ex1 sum or 循环求和
clear;
tic
    i=1:20;
    res1=sum(1./(i.^2+factorial(i)));      % i1为矩阵 运算符要加.
    vpa(res1,20)             %% 连续性阶乘还可以用 n!=gamma（n+1）
toc

tic
    res2=0;
    for i2=1:20,
        res2=res2+1/(i2^2+factorial(i2));  %运算符不用加. 因为i2为一个数
    end;
    vpa(res2,20)   %% vpa时for效率高，无vpa时sum效率高
toc

