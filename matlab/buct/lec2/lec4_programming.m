%% MATLAB 编程
% Ex1
% load logo
% surf(L,R)
% n=size(L,1);
% axis off
% axis([1 n 1 n -0.4 0.5])
% view(-37.5,40)

% 基本的函数编写
[Res1, Res2] = lec4_fun(1, 5)

% 不定长输入参数
nargin_1arg=lec4_nargin(5)      % X^2 -> 5^2
nargin_2arg=lec4_nargin(5,3)    % X^Y -> 5^3

% 不定长输出参数
tmp_vararg=rand(5);
[var11]=lec4_varargin(tmp_vararg)
[var21, var22, var23]=lec4_varargin(tmp_vararg)

