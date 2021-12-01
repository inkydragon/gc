clear;

for n = 1:1:6
    for j = 2:1:11
        u(j,n) = exp(-pi^2*0.2*(n-1)/4)*sin(pi*0.1*(j-1))*100;
    end
end

for m = 1:6
    u(:, m)'
end
