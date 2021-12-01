%% @mpic3 边界条件
%　U(x,t0)=F(x)
%　U=U(x,t0)  ;   F=F(x)
% 【u1】      =  【f1(x)】
% 【u2】(x,t0)   【f2(x)】

function u0=mpic3(x)
u0=[
    exp(-x^2)/sqrt(pi);
    1
    ];