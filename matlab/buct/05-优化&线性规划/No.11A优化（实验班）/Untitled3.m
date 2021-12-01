clear
% c =[];
% ceq = @(x)power(x(1),2)+power(x(2),2)-x(3);
lp_con = @(x)[[],power(x(1),2)+power(x(2),2)-x(3)];

x=1:3;
[c1 ceq1] = lp_con2(x)
% [c2 ceq2] = lp_con(x)
ans = lp_con(x)
