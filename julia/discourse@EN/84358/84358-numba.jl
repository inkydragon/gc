using MKL
using Printf
using SparseArrays
using BenchmarkTools
using NearestNeighbors
using LoopVectorization
import VectorizedRoutines.Matlab: meshgrid
using Random


function fun(data,c)
   x = data[:,1]; y = data[:,2]; z = data[:,3]; n = length(x);
   A,A1,B1,C1,A2,B2,C2 = zeros(n,n),zeros(n,n),zeros(n,n),zeros(n,n),zeros(n,n),zeros(n,n),zeros(n,n)

   for i in 1:n
         @inbounds for k in 1:n
           xx = x[k]-x[i]
           yy = y[k]-y[i]
           zz = z[k]-z[i]
           xyz = sqrt(xx^2+yy^2+zz^2)

           A[i,k] = sqrt(xyz^2+c^2)
           A1[i,k] = xx/A[i,k]
           A2[i,k] = 1/A[i,k]-xx^2/A[i,k]^3
           B1[i,k] = yy/A[i,k]
           B2[i,k] = 1/A[i,k]-yy^2/A[i,k]^3
           C1[i,k] = zz/A[i,k]
           C2[i,k] = 1/A[i,k]-zz^2/A[i,k]^3

       end
   end
   return A,A1,B1,C1,A2,B2,C2
end


function fun2(data)
    x = data[:,1]; y = data[:,2]; z = data[:,3];o = zero(x); II = ones(size(x));
    a =   [II x y z x .^2 x.*y x.*z y .^2 y.*z z .^2 x .^3 x .^2 .*y x .^2 .*z x.*y .^2 x.*y.*z x.*z .^2 y .^3 y .^2 .*z y.*z .^2 z .^3]
    a1 =  [o II o o x*2 y z o o o 3*x .^2 2*x.*y 2*x.*z y .^2 y.*z z .^2 o o o o]
    b1 =  [o o II o o x o y*2 z o o x .^2 o x.*y*2 x.*z o 3*y .^2 2*y.*z z .^2 o]
    c1 =  [o o o II o o x o y z*2 o o x .^2 o x.*y x.*z*2 o y .^2 y.*z*2 3*z .^2]
    a2 = [o o o o II*2 o o o o o x*6 2*y 2*z o o o o o o o]
    b2 = [o o o o o o o II*2 o o o o o x*2 o o y*6 2*z o o]
    c2 = [o o o o o o o o o II*2 o o o o o x*2 o o y*2 z*6]

    return a,a1,b1,c1,a2,b2,c2
end

function main(st,data::Array{Float64,2},p::Array{Int64,1},m)
    N = length(data[:,1])
    W,W11,W12,W13,W21,W22,W23 = spzeros(N,N),spzeros(N,N),spzeros(N,N),spzeros(N,N),spzeros(N,N),spzeros(N,N),spzeros(N,N)
    
    dd = zeros(20,20);
    @inbounds for i in p
       id=st[i]
       t_data = data[id,:];
       @show size(t_data)
       A,A1,B1,C1,A2,B2,C2 = fun(t_data,m)
       a,a1,b1,c1,a2,b2,c2  = fun2(t_data)
        # println(size(A))
        # println(size(a))
        # println(size(t_data))
        # break
        
       R = [A a; a' dd];
       ind = filter(j -> id[j] == i,axes(id, 1)); 
       L = [[A;a'][:,ind] [A1;a1'][:,ind] [B1;b1'][:,ind] [C1;c1'][:,ind] [A2;a2'][:,ind] [B2;b2'][:,ind] [C2;c2'][:,ind]];

       soln = (R\L)[1:length(t_data[:,1]),:]; 
       W[i,id] = soln[:,1]
       W11[i,id] = soln[:,2]
       W12[i,id] = soln[:,3]
       W13[i,id] = soln[:,4]
       W21[i,id] = soln[:,5]
       W22[i,id] = soln[:,6]
       W23[i,id] = soln[:,7]
    end
    return W,W11,W12,W13,W21,W22,W23
end

Random.seed!(84358)
N = 15
PT = rand(N^3,3);
ip =collect(1:N^3);
xx,yy,zz =  PT[:,1], PT[:,2], PT[:,3]; data = [xx yy zz];

r = 0.3

balltree = BallTree(data')
st = inrange(balltree, data', r, true)  # https://github.com/KristofferC/NearestNeighbors.jl
m = 0.5

# main(st,PT,ip,m)
