using MKL
using Printf
using SparseArrays
using BenchmarkTools
using NearestNeighbors
using LoopVectorization
import VectorizedRoutines.Matlab: meshgrid
using Random

struct FunTemp
    A  :: Matrix{Float64}
    A1 :: Matrix{Float64}
    B1 :: Matrix{Float64}
    C1 :: Matrix{Float64}
    A2 :: Matrix{Float64}
    B2 :: Matrix{Float64}
    C2 :: Matrix{Float64}
    
    function FunTemp(N::Int64)
        dims = (N, N)
        new(zeros(dims),
            zeros(dims),zeros(dims),zeros(dims),
            zeros(dims),zeros(dims),zeros(dims))
    end
end

function viewFunTemp(tmp::FunTemp, N::Int64)
    return view(tmp.A, 1:N, 1:N), 
        view(tmp.A1, 1:N, 1:N), view(tmp.B1, 1:N, 1:N), view(tmp.C1, 1:N, 1:N), 
        view(tmp.A2, 1:N, 1:N), view(tmp.B2, 1:N, 1:N), view(tmp.C2, 1:N, 1:N)
end

function fun!(tmp::FunTemp, _data, c)
    x = @view _data[:,1]
    y = @view _data[:,2]
    z = @view _data[:,3]
    n = length(x)

    for i in 1:n
        for k in 1:n
            xx = x[k] - x[i]
            yy = y[k] - y[i]
            zz = z[k] - z[i]
            xyz = sqrt(xx^2 + yy^2 + zz^2)

            tmp.A[i,k]  = sqrt(xyz^2 + c^2)
            tmp.A1[i,k] = xx / tmp.A[i,k]
            tmp.A2[i,k] =  1 / tmp.A[i,k] - xx^2 / tmp.A[i,k]^3
            tmp.B1[i,k] = yy / tmp.A[i,k]
            tmp.B2[i,k] =  1 / tmp.A[i,k] - yy^2 / tmp.A[i,k]^3
            tmp.C1[i,k] = zz / tmp.A[i,k]
            tmp.C2[i,k] =  1 / tmp.A[i,k] - zz^2 / tmp.A[i,k]^3
        end
    end
end


function fun2(data)
    x = data[:,1]; y = data[:,2]; z = data[:,3];o = zero(x); II = ones(size(x));
    a =  [II x y z x.^2 x.*y x.*z y .^2 y.*z z .^2 x .^3 x .^2 .*y x .^2 .*z x.*y .^2 x.*y.*z x.*z .^2 y .^3 y .^2 .*z y.*z .^2 z .^3]
    a1 = [o II o o x*2 y z o o o 3*x .^2 2*x.*y 2*x.*z y .^2 y.*z z .^2 o o o o]
    b1 = [o o II o o x o y*2 z o o x .^2 o x.*y*2 x.*z o 3*y .^2 2*y.*z z .^2 o]
    c1 = [o o o II o o x o y z*2 o o x .^2 o x.*y x.*z*2 o y .^2 y.*z*2 3*z .^2]
    a2 = [o o o o II*2 o o o o o x*6 2*y 2*z o o o o o o o]
    b2 = [o o o o o o o II*2 o o o o o x*2 o o y*6 2*z o o]
    c2 = [o o o o o o o o o II*2 o o o o o x*2 o o y*2 z*6]

    return a,a1,b1,c1,a2,b2,c2
end

function main(st,data::Array{Float64,2},p::Array{Int64,1},m)
    N = length(data[:,1])
    W,W11,W12,W13,W21,W22,W23 = spzeros(N,N),spzeros(N,N),spzeros(N,N),spzeros(N,N),spzeros(N,N),spzeros(N,N),spzeros(N,N)
    tmpN = [length(s) for s in st] |> maximum
    tmp1 = FunTemp(tmpN)
    
    dd = zeros(20,20);
    @inbounds for i in p
        id=st[i]
        t_data = data[id,:];
        fun!(tmp1, t_data, m)
        viewN, _ = size(t_data)
        A,A1,B1,C1,A2,B2,C2 = viewFunTemp(tmp1, viewN)
        # A,A1,B1,C1,A2,B2,C2 = fun(t_data,m)
        a,a1,b1,c1,a2,b2,c2  = fun2(t_data)
        # println(size(A))
        # println(size(a))
        # println("t_data=$(size(t_data))")
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
N0 = 15
PT = rand(N0^3,3);
ip =collect(1:N0^3);
xx0,yy0,zz0 =  PT[:,1], PT[:,2], PT[:,3]; 
data0 = [xx0 yy0 zz0];

r = 0.3

balltree = BallTree(data0')
st0 = inrange(balltree, data0', r, true)  # https://github.com/KristofferC/NearestNeighbors.jl
m = 0.5

# main(st0,PT,ip,m)
