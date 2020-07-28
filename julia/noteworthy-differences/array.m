%% 数组的构造
[1, 2, 3]
%      1     2     3

[1, [0 0], 3]
%      1     0     0     3

[1 2 3]
%      1     2     3
[1,2,3] == [1 2 3]
%      1     1     1

[1; 2; 3]
%      1
%      2
%      3

[1 2; 3 4]
%      1     2
%      3     4

rand(3)
%     0.8147    0.9134    0.2785
%     0.9058    0.6324    0.5469
%     0.1270    0.0975    0.9575

rand(3, 1)
%     0.4218
%     0.9157
%     0.7922

rand(2, 2)
%     0.9649    0.9706
%     0.1576    0.9572


%% 数组的拼接
a = [1 2];

[a a a]
%      1     2     1     2     1     2

[a; a; a]
%      1     2
%      1     2
%      1     2

b = [3 4];
[a b; a b]
%      1     2     3     4
%      1     2     3     4

[a a; b b]
%      1     2     1     2
%      3     4     3     4


%% 数组的索引
a = [1 2 3; 4 5 6]
%      1     2     3
%      4     5     6
a(1, 1)
%      1

c = {1 2 3; 4 5 6}
%     [1]    [2]    [3]
%     [4]    [5]    [6]
horzcat(c{:})
%     1     4     2     5     3     6

1:5
%     1     2     3     4     5

1:2:10
%     1     3     5     7     9


%% sum, prod, max
a = [1 2 3; 4 5 6]
%      1     2     3
%      4     5     6

sum(a)
%      5     7     9

prod(a)
%      4    10    18

max(a)
%      4     5     6


%% 布尔运算
a = [true true false false]
%      1     1     0     0
b = [true false true false]
%      1     0     1     0

a & b   % and(a, b)
%      1     0     0     0
a | b   % or(a, b)
%      1     1     1     0
xor(a, a)
%      0     0     0     0


A = [1 2 3 4];
(A == 1) | (A == 2)
%      1     1     0     0

A( (A == 1) | (A == 2) )
%      1     2

A = [1 2 3 4];
A(A>3)
%      4
A(A>3) = []
% A =     1     2     3


%% 赋值
a = [1 2 3]
% a =     1     2     3
b = a
% b =     1     2     3

b(2) = 0
% b =     1     0     3
a
% a =     1     2     3


a = [];
a(4) = 3.2
% a =         0         0         0    3.2000
a(5) = 7
% a =     0     0     0     0     7
a(end+1) = 10
% a =     0     0     0     0     7    10


%% 杂项
sqrt(-1)
%    0.0000 + 1.0000i
i
%    0.0000 + 1.0000i
j
%    0.0000 + 1.0000i

i * i
%     -1
i * j
%     -1
i * i == sqrt(-1)
%      0