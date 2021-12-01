%% Q2
clear;

% Ax=b
A=hilb(10);
x=ones(10,1);

b=A*x;
b2=b.*(1+0.01);
x1=A\b;
x2=A\b2;
dx=(x2-x1)./x1;

fprintf('      b      x     b2     x2     △x\n');
fprintf('   %.4f %.4f %.4f %.4f %.2d\n',[b';x';b2';x2';dx']);
