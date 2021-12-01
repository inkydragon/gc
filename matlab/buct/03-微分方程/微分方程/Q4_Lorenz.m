%% Q4_Lorenz
function dydt=Q4_Lorenz(t,y)
dydt=[
    -8/3*y(1)+y(2)*y(3);
    -10*y(2)+10*y(3);
    -y(1)*y(2)+28*y(2)-y(3)
    ];