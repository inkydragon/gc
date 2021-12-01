clear,
a1 = zeros(2,3)    %  2x3 全零阵
 
a2 = ones(3)       %  3x3 全1阵

a3 = eye(3,4)      %  3x4 对角阵

a4 = hilb(4)       %  4x4 Hilbert 矩阵

syms a5
a5 = sym(hilb(4))  %  符号表示的 希尔伯特矩阵