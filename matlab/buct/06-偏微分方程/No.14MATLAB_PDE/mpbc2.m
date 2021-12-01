%% @mpbc3 边界初值
% Px + Qx*F = 0
% Pa,Pb=p(x,t,u) ; Qa,Qb=q(x,t) ; F=f(x,t,du/dx)
% x=a,b  or x=±a
% 【p1(u)】 + 【q1(x)】*【f1(u_x)】 = 【0】
% 【p2(u)】   【q2(x)】 【f2(u_x)】   【0】


function [pa,qa,pb,qb]=mpbc2(xa,ua,xb,ub,t)
pa=[
    ua(1)
    ];
qa=[
    0
    ];
pb=[
    ub(1)
    ];
qb=[
    0
    ];