%% eps
clear,

[X,Y]=meshgrid(-7:7);    
R = sqrt(X.^2+Y.^2)+eps; %%% +eps 避免顶点缺失
Z = sin(R)./R;
%mesh(X,Y,Z)
surfc(X,Y,Z)


