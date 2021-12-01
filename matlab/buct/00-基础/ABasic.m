%% MATLAB = MATrix  LABoratory
clear;
%% 变量名规则
% 由一个字母引导，后面可以为其他字符
% 区分大小写   Abc      ABc
% 有效         MYvar12, MY_Var12, MyVar12_
% 错误的变量名 12MyVar, _MyVar12  
%% 基本运算
% floor(a)	向下取整
% ceil(a)   向上取整
% round(a)	四舍五入
% factor(n)	质因数分解
% gcd(m,n)	最大公约数
% lcm(m,n)	最小公倍数
%% Ex1 sum or 循环求和
% tic
% i=1:20;
% res1=sum(1./(i.^2+factorial(i)));      % i1为矩阵 运算符要加.
% res1           %% 连续性阶乘还可以用 n!=gamma（n+1）
% toc
% 
% tic
% res2=0;
% for i2=1:20,
%     res2=res2+1/(i2^2+factorial(i2));  %运算符不用加. 因为i2为一个数
% end;
% res2  %% vpa时for效率高，无vpa时sum效率高
% toc
%% 流程控制 if ifelse ; switch
% % ---- if ifelse -----------------------------------------------------------
% x = 1.8;
% if x>=2
%     a = 'pass';
% elseif x==1.8
%     a = '1.8';
% else
%     a= '不通过';
% end
% a
% 
% % ---- switch -----------------------------------------------------------
% n = input('Enter a number: ');
% switch n
%     case -1
%         disp('negative one')
%     case 0
%         disp('zero')
%     case 1
%         disp('positive one')
%     otherwise
%         disp('other value')
% end
%% 循环结构 for ; while
% % ---- for -----------------------------------------------------------
% s =0;
% for i=1:20
%     s = s+i;
% end
% s
% % ---- while -----------------------------------------------------------
% s = 0; i = 1;
% while (i<=20)
%     s = s+1/i; 
%     i = i+1;
% end
% s
%% 显示圆周率的近似值 vpa
% vpa(pi)
% vpa(pi,100)
%% 积分 int
% syms a b x y;
% int(a^2+b,a)
% int(sin(x)/x)
%% 求导 diff
% f=x^2*exp(x*y)*sin(x+y);
% diff(f,x,2)
% diff(diff(f,x,2),y)
% latex(diff(f,x,2))
%% 函数与极限 limit
% syms a b x;
% f = b^2*sin(a*x)/x;
% L = limit(f,x,0,'left')
% L1 = limit(exp(x),-inf)
%% 幂级数 taylor
% x0 = taylor(exp(x),x,3)      % 在x=0处展开
% x1 = taylor(exp(x),x,3,1)    % 在x=1处展开
%% 矩阵表示
% A=[1 2 3;2 4 5; 3 6 7]
% a1 = zeros(2,3)    %  2x3 全零阵
% a2 = ones(3)       %  3x3 全1阵
% a3 = eye(3,4)      %  3x4 
% a4 = hilb(4)       % 4x4 Hilbert matrix
% syms a5
% a5 = sym(hilb(4))
%% 矩阵基本运算                
% A = [16 2 3 13 2;
%   5 11 10 8 6;
%   9  7 6 12 9;
%   4 14 15 12 3]
% B = A(1:2, 3:4)          %%% 用A的1-2行、3-4列的元素构成新矩阵
% D = det(B)               %%% 矩阵的行列式
% inv_B = inv(B)           %%% 矩阵的逆
% inv_B_exa = inv(sym(B))  % 矩阵的j逆 精确值
% rA = rank(A)             %%% 矩阵的秩
% 
% [v,d] = eig(B)           %%% 矩阵的特征值和特征向量
% [v_exa,d_exa] = eig(sym(B))  % 矩阵的特征值和特征向量 精确值
% 
% s = eig(B)              %%% 矩阵的特征值
% s_exa = eig(sym(B))     % 矩阵的特征值 精确值
% 
% [v,J] = jordan(sym(B))  %%% 矩阵的对角化 精确值
% poly(B)                 % 矩阵B的多项式
% rref(A)                 % A的列向量组的极大无关组
%% Q4 矩阵方程
% % a1 .* X .* a2 = a3
% a1=[0 1 0; 
%     1 0 0; 
%     0 0 1];
% a2=[1 0 0; 
%     0 0 1; 
%     0 1 0];
% a3=[1 -4  3; 
%     2  0 -1; 
%     1 -2  0];
% cond(a1)       % 计算a1的条件数
% fprintf('Q4:')
% x=(a1\a3)/a2