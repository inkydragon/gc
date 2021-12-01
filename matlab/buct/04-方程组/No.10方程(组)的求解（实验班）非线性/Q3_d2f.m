%% Q3_d2f
function L=Q3_d2f(theta)
h=2;
v=13.6;
g=9.8;

y=((4*v^3*cos(2*theta)*sin(2*theta))/g^2 - (8*h*v*cos(theta)*sin(theta))/g)/(2*((v^4*sin(2*theta)^2)/(4*g^2) + (2*h*v^2*cos(theta)^2)/g)^(1/2)) - (((v^3*sin(2*theta)^2)/g^2 + (4*h*v*cos(theta)^2)/g)*((v^4*cos(2*theta)*sin(2*theta))/g^2 - (4*h*v^2*cos(theta)*sin(theta))/g))/(4*((v^4*sin(2*theta)^2)/(4*g^2) + (2*h*v^2*cos(theta)^2)/g)^(3/2)) + (2*v*cos(2*theta))/g;