%% @mp2 偏微分方程组
% C*dU_t = d/dx*F + S
% C,F,S=c,f,s(x,t,u,du/dx)
% 【 c1 】* 【 u1t 】 = d/ * 【 f1(ux) 】 + 【 s1(u) 】
% 【 c2 】  【 u2t 】   dx   【 f2(ux）】   【 s2(u) 】
function [c,f,s]=mp(x,t,u,du)
c=[
    1
    ];
f=[
    0
    ];
s=[
   -u(1)*du(1)
    ];