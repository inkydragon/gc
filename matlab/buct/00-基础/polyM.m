clear,
A = [
    16 2  3  13 2;
    5  11 10 8  6;
    9  7  6  12 9;
    4  14 15 12 3]
 B = A(1:4, 1:4)
%% 矩阵A的列向量组的极大线性无关组
A1 = rref(A)
%% 矩阵多项式
poly(B)
B_polynomial = charpoly(B)
%% 矩阵方程的解
% A.*X=B
% X= A\B
% a1 .* X .* a2 = a3
% x=(a1\a3)/a2
b = [ 3 2 5 7]
cond(B)
x = B/b    %%% solve xB = b
y = B\b'   %%% solve By = b'
 