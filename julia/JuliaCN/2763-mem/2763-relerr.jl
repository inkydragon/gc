
function rel_err(
    u::Array{Float64,2}, v::Array{Float64,2}, 
    u0::Array{Float64,2}, v0::Array{Float64,2})
    temp1 = sum((u - u0) .^ 2 + (v - v0) .^ 2)
    temp2 = sum(u .^ 2 + v .^ 2)
    err = sqrt(temp1) / sqrt(temp2 + 1e-30)
    
    err
end

function mainFlow(iterStepMax::Int64)
Q = 9 #D2Q9
nx = 1200 #lattice number in horizontal direction
ny = 600 #lattice number in vertical direction
U = 0.1 #inlet velocity
cx = [1.0 0.0 -1.0 0.0 1.0 -1.0 -1.0 1.0 0.0] #velocity components in horizontal direction
cy = [0.0 1.0 0.0 -1.0 1.0 1.0 -1.0 -1.0 0.0] #velocity components in vertical direction
w = [1.0 / 9.0 1.0 / 9.0 1.0 / 9.0 1.0 / 9.0 1.0 / 36.0 1.0 / 36.0 1.0 / 36.0 1.0 / 36.0 4.0 / 9.0] #weight parameters
# cx = [1.0, 0.0, -1.0, 0.0, 1.0, -1.0, -1.0, 1.0, 0.0] #velocity components in horizontal direction
# cy = [0.0, 1.0, 0.0, -1.0, 1.0, 1.0, -1.0, -1.0, 0.0] #velocity components in vertical direction
# w = [1.0 / 9.0, 1.0 / 9.0, 1.0 / 9.0, 1.0 / 9.0, 1.0 / 36.0, 1.0 / 36.0, 1.0 / 36.0, 1.0 / 36.0, 4.0 / 9.0] #weight parameters

rel_err_temp = Array{Float64}(undef, nx, ny)
ρ = ones(Float64, nx, ny) #initial density
u = zeros(Float64, nx, ny) #horizontal velocity component
v = zeros(Float64, nx, ny) #vertical velocity component
u0 = zeros(Float64, nx, ny) #horizontal velocity component before iteration
v0 = zeros(Float64, nx, ny) #vertical velocity component befre iteration
# u0 = Array{Float64}(undef, nx, ny)
# v0 = Array{Float64}(undef, nx, ny)
uv = zeros(Float64, nx, ny) #resultant velocity
f = zeros(Float64, nx, ny, Q) #distribution function
feq = zeros(Float64, nx, ny, Q) #equilibrium distribution function

dx = 1.0 #horizontal lattice length
dy = 1.0 #vertical lattice length
lx = dx * nx #horizontal domain length
ly = dy * ny #vertical domain length
dt = dx #dt = 1.0
c = dx / dt #lattice sound speed
Re = 1000.0 #Reynoldz number
ν = U * ly / Re #kinematic viscousity
τ = 3.0ν + 0.5 #relaxation time
ω = 1.0 / τ #relaxation frequency
println("Re = ", Re, ", τ = ", τ) #instead of "Re = $Re, τ = $τ"
# iterStepMax = 10000
ε = 1.0e-6 #convergence requirement

@views u[1, 2:ny-1] .= U
for iterStep = 1:iterStepMax
    collision(nx, ny, Q, u, v, ρ, cx, cy, w, ω, f, feq)
    streaming(Q, cx, cy, f)
    boundaryCondition(nx, ny, u, v, ρ, U, f)
    macroQuantity(nx, ny, Q, u, v, uv, u0, v0, ρ, cx, cy, f)
    
    # temp1 = sum((u[:, :] - u0[:, :]) .^ 2 + (v[:, :] - v0[:, :]) .^ 2)
    # temp1 = sum((u - u0) .^ 2 + (v - v0) .^ 2)
    # temp2 = sum(u .^ 2 + v .^ 2)
    # err = sqrt(temp1) / sqrt(temp2 + 1e-30)
    @. rel_err_temp = (u - u0)^2 + (v - v0)^2
    temp1 = sum(rel_err_temp)
    @. rel_err_temp = u^2 + v^2
    temp2 = sum(rel_err_temp)
    
    err = sqrt(temp1 / (temp2 + 1e-30))
    if err <= ε
        break
    end
end
    nx, ny, u, v
end

# function collision(nx, ny, Q, u, v, ρ, cx, cy, w, ω, f, feq)
# function collision(nx, ny, Q, u, v, ρ::Array{Float64,2}, cx, cy, w, ω, f, feq)
function collision(nx::Int64, ny::Int64, Q::Int64, 
    u::Array{Float64,2}, v::Array{Float64,2}, ρ::Array{Float64,2}, 
    cx::Array{Float64,2}, cy::Array{Float64,2}, w::Array{Float64,2}, 
    ω::Float64, 
    f::Array{Float64,3}, feq::Array{Float64,3}
)
for j = 1:ny, i = 1:nx
    t1 = u[i, j] * u[i, j] + v[i, j] * v[i, j]
    for k = 1:Q
        t2 = u[i, j] * cx[k] + v[i, j] * cy[k]
        feq[i, j, k] = ρ[i, j] * w[k] * (1.0 + 3.0t2 + 4.5 * t2^2 - 1.5t1)
        f[i, j, k] = (1.0 - ω) * f[i, j, k] + ω * feq[i, j, k]
    end
end
end

# function streaming(Q, cx, cy, f)
function streaming(Q::Int64, 
    cx::Array{Float64,2}, cy::Array{Float64,2}, 
    f::Array{Float64,3}
)
for k = 1:Q
    @views f[:, :, k] .= circshift(f[:, :, k], [cx[k], cy[k]])
end
end

# function boundaryCondition(nx, ny, u, v, ρ, U, f)
function boundaryCondition(nx::Int64, ny::Int64, 
    u::Array{Float64,2}, v::Array{Float64,2}, ρ::Array{Float64,2}, U::Float64, f::Array{Float64,3}
)
#left
# @views f[1, 2:ny-1, 1] = f[1, 2:ny-1, 3] + ρ[1, 2:ny-1] .* U * 2.0 / 3.0
# @views f[1, 2:ny-1, 5] = f[1, 2:ny-1, 7] - 0.5 .* (f[1, 2:ny-1, 2] - f[1, 2:ny-1, 4]) + ρ[1, 2:ny-1] .* U / 6.0
# @views f[1, 2:ny-1, 8] = f[1, 2:ny-1, 6] + 0.5 .* (f[1, 2:ny-1, 2] - f[1, 2:ny-1, 4]) + ρ[1, 2:ny-1] .* U / 6.0
@views @. f[1, 2:ny-1, 1] = f[1, 2:ny-1, 3] + ρ[1, 2:ny-1] * U * 2.0 / 3.0
@views @. f[1, 2:ny-1, 5] = f[1, 2:ny-1, 7] - 0.5 * (f[1, 2:ny-1, 2] - f[1, 2:ny-1, 4]) + ρ[1, 2:ny-1] * U / 6.0
@views @. f[1, 2:ny-1, 8] = f[1, 2:ny-1, 6] + 0.5 * (f[1, 2:ny-1, 2] - f[1, 2:ny-1, 4]) + ρ[1, 2:ny-1] * U / 6.0
@views u[1, 2:ny-1] .= U
@views v[1, 2:ny-1] .= 0.0

#right
# @views f[nx, :, 3] = f[nx-1, :, 3]
# @views f[nx, :, 6] = f[nx-1, :, 6]
# @views f[nx, :, 7] = f[nx-1, :, 7]
@views @. f[nx, :, 3] = f[nx-1, :, 3]
@views @. f[nx, :, 6] = f[nx-1, :, 6]
@views @. f[nx, :, 7] = f[nx-1, :, 7]

#bottom
# @views f[:, 1, 2] = f[:, 1, 4]
# @views f[:, 1, 5] = f[:, 1, 7]
# @views f[:, 1, 6] = f[:, 1, 8]
@views @. f[:, 1, 2] = f[:, 1, 4]
@views @. f[:, 1, 5] = f[:, 1, 7]
@views @. f[:, 1, 6] = f[:, 1, 8]
@views u[:, 1] .= 0.0
@views v[:, 1] .= 0.0

#top
# @views f[:, ny, 4] = f[:, ny, 2]
# @views f[:, ny, 8] = f[:, ny, 6]
# @views f[:, ny, 7] = f[:, ny, 5]
@views @. f[:, ny, 4] = f[:, ny, 2]
@views @. f[:, ny, 8] = f[:, ny, 6]
@views @. f[:, ny, 7] = f[:, ny, 5]
@views u[:, ny] .= 0.0
@views v[:, ny] .= 0.0
end


# function macroQuantity(nx, ny, Q, u, v, uv, u0, v0, ρ, cx, cy, f)
function macroQuantity(nx::Int64, ny::Int64, 
    Q::Int64, u::Array{Float64,2}, v::Array{Float64,2}, 
    uv::Array{Float64,2}, 
    u0::Array{Float64,2}, v0::Array{Float64,2}, 
    ρ::Array{Float64,2}, 
    cx::Array{Float64,2}, cy::Array{Float64,2}, 
    f::Array{Float64,3}
)
# ρ[:, :] = sum(f, dims = 3)
# u0[:, :] = u[:, :]
# v0[:, :] = v[:, :]
# ρ = sum(f, dims = 3)
# u0 = copy(u)
# v0 = copy(v)
sum!(ρ, f)
copy!(u0, u)
copy!(v0, v)

for j = 1:ny, i = 1:nx
    uSum = 0.0
    vSum = 0.0
    for k = 1:Q
        uSum += f[i, j, k] * cx[k]
        vSum += f[i, j, k] * cy[k]
    end
    u[i, j] = uSum / ρ[i, j]
    v[i, j] = vSum / ρ[i, j]
end
# uv[:, :] = @. sqrt(u[:, :]^2 + v[:, :]^2)
# uv = @. sqrt(u^2 + v^2)
@. uv = sqrt(u^2 + v^2)
# @. uv[:] = sqrt(u[:]^2 + v[:]^2)
end

mainFlow(50)
# mainFlow(50)
# using ProfileView
# @profview mainFlow(50)
# nx, ny, U, V = mainFlow(50)
# 
# function mgrid(nx, ny)
#     reshape([y for y=1:ny for x=1:nx], (nx, ny)),
#     reshape([x for y=1:ny for x=1:nx], (nx, ny))
# end

# using PyPlot
# X, Y = mgrid(nx, ny)
# streamplot(X, Y, U, V)
# gcf()
