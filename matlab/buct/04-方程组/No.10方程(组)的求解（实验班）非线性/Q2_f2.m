%% Q2_f
function y=Q2_f2(x)
y = -[ 
        x(1)-0.7*sin(x(1))-0.2*cos(x(2));
        x(2)-0.7*cos(x(1))+0.2*sin(x(2))
    ];	
end 
