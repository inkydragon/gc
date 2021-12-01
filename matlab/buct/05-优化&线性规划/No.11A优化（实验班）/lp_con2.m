function [c,ceq] = lp_con2(x)
c =[];
ceq = power(x(1),2)+power(x(2),2)-x(3);