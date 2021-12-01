%% 变参函数
% `nargin, nargout` 分别用来检验函数输入输出时的参数个数
function f=lec4_nargin(a,b)
if (nargin == 1)
    f=a.^2;
elseif (nargin == 2)
    f=a.*b;
end
