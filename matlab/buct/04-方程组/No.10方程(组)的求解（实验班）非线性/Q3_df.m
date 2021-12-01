%% Q3_f
function L=Q3_df(theta)
h=2;
v=13.6;
g=9.8;

L=((v^4*cos(2*theta)*sin(2*theta))/g^2 - (4*h*v^2*cos(theta)*sin(theta))/g)/(2*((v^4*sin(2*theta)^2)/(4*g^2) + (2*h*v^2*cos(theta)^2)/g)^(1/2)) + (v^2*cos(2*theta))/g ;