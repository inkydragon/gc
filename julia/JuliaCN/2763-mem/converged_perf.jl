
nx = 1200
ny = 600 
arr_tmp = Array{Float64}(undef, nx, ny)
u  = rand(Float64, nx, ny)
v  = rand(Float64, nx, ny) 
u0 = rand(Float64, nx, ny)
v0 = rand(Float64, nx, ny) 

function relative_error!(arr_tmp, u, v, u0, v0)
    @. arr_tmp = (u-u0)^2 + (v-v0)^2
    temp1 = sum(arr_tmp)
    @. arr_tmp = u^2 + v^2
    temp2 = sum(arr_tmp)
    
    # eps(Float64) == 2.220446049250313e-16
    sqrt( temp1 / (temp2 + 1e-16) )
end

converged!(arr_tmp, u, v, u0, v0, ε=1e-6) =
    relative_error!(arr_tmp, u, v, u0, v0) <= ε

converged!(arr_tmp, u, v, u0, v0)
