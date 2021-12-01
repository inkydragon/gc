clear;
%% Q1 
i=1:13;
ans1=sum(factorial(2*i-1));
fprintf('Q1:\n1！+3！+...+25! = %d\n\n', ans1)

%% Q2
q2=pi/20;
i=0:10;
ans2=sum(power(-1,i)+power(q2,2*i)/factorial(2*i));
fprintf('Q2:\n近似值 cos(π/20) ≈ %d\n', ans2)
fprintf('精确值 cos(π/20) = %f\n\n',cos(pi/20))

%% Q3
a=[ 2  2 -2; 
    2  5 -4; 
   -2 -4  5];
fprintf('Q3:\n(1)')
ans31 = a^10 - 8*a + a^6
fprintf('(2)\n|A| = %d\nRank(A) = %d\n', det(a), rank(a))
fprintf('(3)\n使A对角化的过渡矩阵')
[v,j]=jordan(sym(a))  % v过渡矩阵  j对角化矩阵
v\a*v

%% Q4
% a1 .* X .* a2 = a3
a1=[0 1 0; 1 0 0; 0 0 1];
a2=[1 0 0; 0 0 1; 0 1 0];
a3=[1 -4 3; 2 0 -1; 1 -2 0];
Condition=cond(a1)
fprintf('条件数较小，可以直接计算\n')
fprintf('Q4:')
x=(a1\a3)/a2
