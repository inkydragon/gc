%input data
clear
x=[20.5 32.5 51 73 95.7]';
y=[765 826 873 942 1032];

%%% calculate the matrix of coefficients
m = 1;
A = ones(m+1, m+1); B = ones(m+1,1);

for k = 1:1:(m+1)
    for j = 1:1:(m+1)
        c1 = x.^(m+1-k);
        c2 = x.^(m+1-j);
        A(k,j) = c1'*c2;
        A(j,k) = A(k,j);
    end
    B(k,1) = y*c1;
end
A,B
%%% compute the condition number of A
condition_number = cond(A)
%%% solve the equation
'coefficient',a = A\B
