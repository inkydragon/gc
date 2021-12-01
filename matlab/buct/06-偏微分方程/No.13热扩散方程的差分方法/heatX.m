clear;
X = 0:0.1:1;
T = 0:0.01:1;
for j = 1:1:11
     U(j,1) = sin(pi*(j-1)/10)*100;
end

for n = 1:1:100
    for j = 1:1:9
        U(j+1,n+1)=0.25*U(j,n)+0.5*U(j+1,n)+0.25*U(j+2,n);
    end
end

for m = 1:6
    U(:, 20*(m-1)+1)'
end
