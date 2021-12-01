m = 50;
A = rand(m,2);
for n=1:m
    B(n,1) = normtransform(A(n,1),A(n,2));
end
C = 3*B+1;
D = randn(m,1);
D1 = 3*D+1;
h1 = normal_fun(C);
h2 = normal_fun(D1);
plot(C,h1,'r o',D1,h2,'b .')