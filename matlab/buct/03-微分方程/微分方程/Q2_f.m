%% Q2_f
% y"+y-sin(0)=0  => y"=sin(y)-y
% y  = y(1)
% y' = y(2)
% y" = y(3)
function dydx=Q2_f(x,y)
dydx=[
    y(2),
    sin(y(1))-y(1)
    ];
