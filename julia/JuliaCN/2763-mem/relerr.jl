
const nx = 1200
const ny = 600

u0 = rand(Float64, nx, ny);
v0 = u0;
u = rand(Float64, nx, ny);
v = u;
rel_err_temp = Array{Float64}(undef, nx, ny);

function relerr0(rel_err_temp::Array{Float64,2},
    u::Array{Float64,2}, v::Array{Float64,2}, 
    u0::Array{Float64,2}, v0::Array{Float64,2})
    temp1 = sum((u - u0) .^ 2 + (v - v0) .^ 2)
    temp2 = sum(u .^ 2 + v .^ 2)
    err = sqrt(temp1) / sqrt(temp2 + 1e-30)
    
    err
end

function relerr1(rel_err_temp::Array{Float64,2},
    u::Array{Float64,2}, v::Array{Float64,2}, 
    u0::Array{Float64,2}, v0::Array{Float64,2})
    @. rel_err_temp = (u - u0)^2 + (v - v0)^2
    temp1 = sum(rel_err_temp)
    
    @. rel_err_temp = u^2 + v^2
    temp2 = sum(rel_err_temp)
    
    sqrt(temp1 / (temp2 + 1e-30))
end

function relerr2(rel_err_temp::Array{Float64,2},
    u::Array{Float64,2}, v::Array{Float64,2}, 
    u0::Array{Float64,2}, v0::Array{Float64,2})
    @. rel_err_temp = (u - u0)^2 + (v - v0)^2
    temp1 = sum(@view rel_err_temp[:])
    
    @. rel_err_temp = u^2 + v^2
    temp2 = sum(@view rel_err_temp[:])
    
    sqrt(temp1 / (temp2 + 1e-30))
end

function relerr3(rel_err_temp::Array{Float64,2},
    u::Array{Float64,2}, v::Array{Float64,2}, 
    u0::Array{Float64,2}, v0::Array{Float64,2})
    square = x -> x^2
    copy!(rel_err_temp, u)
    @. rel_err_temp -= u0
    temp1 = mapreduce(square, +, @view rel_err_temp[:])
    copy!(rel_err_temp, v)
    @. rel_err_temp -= v0
    temp1 += mapreduce(square, +, @view rel_err_temp[:])

    temp2 = mapreduce(square, +, @view u[:]) + 
        mapreduce(square, +, @view v[:])   
    sqrt(temp1 / (temp2 + 1e-30))
end
