%% Q3_f
function L=Q3_f(theta)
h=2;
v=13.6;
g=9.8;

L=power(v,2)*sin(2*theta)/(2*g)+sqrt(power((power(v,2)*sin(2*theta)/(2*g)),2)+2*h*power(v,2)*power(cos(theta),2)/g);