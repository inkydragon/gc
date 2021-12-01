%% Ex1
clear
fplot(@(x) exp(x)-0.5,[-1.5 1.25]);
hold on
fplot(@(x) sqrt(1-x.^2),'r');
fplot(@(x) -sqrt(1-x.^2),'r')
fplot(@(x) x-x,[-1.5 1.25],'k');
hold off

[i,res]=Newt_equ(@Exf,@Exdf,[-2;0],50,1e-6);
fprintf('迭代了%g次,找到的解为[%5.3f,%5.3f]\n',i,res(1),res(2))
[i,res]=Newt_equ(@Exf,@Exdf,[0;1],50,1e-6);
fprintf('迭代了%g次,找到的解为[%5.3f,%5.3f]\n',i,res(1),res(2))