%% 变参函数 不定长输出参数
% `varargin, varargout` 允许输入和输出参数个数任意多
function [varargout]=lec4_varargin(arin)
varargout=cell(nargout);    % varargout 为元胞类型
for i=1:nargout
    varargout{i}=arin(:,i);
end
