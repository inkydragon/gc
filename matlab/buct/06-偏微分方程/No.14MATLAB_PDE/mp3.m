%% @mp2 偏微分方程组
% C*dU_t = d/dx*F + S
% C,F,S=c,f,s(x,t,u,du/dx)
% 【 c1 】* 【 u1_t 】 = d/ * 【 f1(u_x) 】 + 【 s1(u) 】
% 【 c2 】  【 u2_t 】   dx   【 f2(u_x）】   【 s2(u) 】
function [c,f,s]=mp3(x,t,u,du)
a=0;
c=[
    1;
    1
    ];
f=[
    du(1);
    du(2)
    ];
s=[
    a*u(1)*(1-u(2));
    a*(1-u(1))
    ];