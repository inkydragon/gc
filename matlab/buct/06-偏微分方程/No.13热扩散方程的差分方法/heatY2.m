clear;
tau = 0.001; h = 0.1;
b = tau/h^2/4;  %%% b=lambda

for j=1:1:11
    U(j,1) = sin(pi*(j-1)/10)*100;
end

%%%  define A
for i=1:8
    A(i,i+1) = -b;
    A(i+1,i) = -b;
end
for i = 1:9
    A(i,i) = 1+2*b;
end

%%% define initial value
X = U(2:10,1);
X'

for m = 1:1000
    X = A\X;
    if ((m/200-floor(m/200)) == 0) 
    m, X'
    end
end

