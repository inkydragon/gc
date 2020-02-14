const nx = 1200 #lattice number in horizontal direction
const ny = 600 #lattice number in vertical direction
const U = 0.1
const Q = 9
u = rand(Float64, nx, ny); #horizontal velocity component
v = rand(Float64, nx, ny); #vertical velocity component
ρ = ones(Float64, nx, ny); #initial density
f = rand(Float64, nx, ny, Q); #distribution function


function boundaryCondition0!(nx, ny, u, v, ρ, U, f)
nothing
@views @. f[1, 2:ny-1, 1] = f[1, 2:ny-1, 3] + ρ[1, 2:ny-1] * U * 2.0 / 3.0
@views @. f[1, 2:ny-1, 5] = f[1, 2:ny-1, 7] - 0.5 * (f[1, 2:ny-1, 2] - f[1, 2:ny-1, 4]) + ρ[1, 2:ny-1] * U / 6.0
@views @. f[1, 2:ny-1, 8] = f[1, 2:ny-1, 6] + 0.5 * (f[1, 2:ny-1, 2] - f[1, 2:ny-1, 4]) + ρ[1, 2:ny-1] * U / 6.0
@views u[1, 2:ny-1] .= U
@views v[1, 2:ny-1] .= 0.0

@views @. f[nx, :, 3] = f[nx-1, :, 3]
@views @. f[nx, :, 6] = f[nx-1, :, 6]
@views @. f[nx, :, 7] = f[nx-1, :, 7]

@views @. f[:, 1, 2] = f[:, 1, 4]
@views @. f[:, 1, 5] = f[:, 1, 7]
@views @. f[:, 1, 6] = f[:, 1, 8]
@views u[:, 1] .= 0.0
@views v[:, 1] .= 0.0

@views @. f[:, ny, 4] = f[:, ny, 2]
@views @. f[:, ny, 8] = f[:, ny, 6]
@views @. f[:, ny, 7] = f[:, ny, 5]
@views u[:, ny] .= 0.0
@views v[:, ny] .= 0.0

nothing
end

function boundaryCondition1!(nx, ny, u, v, ρ, U, f)
nothing
@. f[1, 2:ny-1, 1] = f[1, 2:ny-1, 3] + ρ[1, 2:ny-1] * U * 2.0 / 3.0

tmp = 0.5 * (f[1, 2:ny-1, 2] - f[1, 2:ny-1, 4]) + ρ[1, 2:ny-1] * U / 6.0
@. f[1, 2:ny-1, 5] = f[1, 2:ny-1, 7] - tmp
@. f[1, 2:ny-1, 8] = f[1, 2:ny-1, 6] + tmp
u[1, 2:ny-1] .= U
v[1, 2:ny-1] .= 0.0

@views @. f[nx, :, 3] = f[nx-1, :, 3]
@views @. f[nx, :, 6] = f[nx-1, :, 6]
@views @. f[nx, :, 7] = f[nx-1, :, 7]

@views f[:, 1, 2] = f[:, 1, 4]
@views f[:, 1, 5] = f[:, 1, 7]
@views f[:, 1, 6] = f[:, 1, 8]
u[:, 1] .= 0.0
v[:, 1] .= 0.0

@views @. f[:, ny, 4] = f[:, ny, 2]
@views @. f[:, ny, 8] = f[:, ny, 6]
@views @. f[:, ny, 7] = f[:, ny, 5]
u[:, ny] .= 0.0
v[:, ny] .= 0.0

nothing
end

function boundaryCondition2!(nx, ny, u, v, ρ, U, f)
nothing
@. f[1, 2:ny-1, 1] = f[1, 2:ny-1, 3] + ρ[1, 2:ny-1] * U * 2.0 / 3.0

tmp = 0.5 * (f[1, 2:ny-1, 2] - f[1, 2:ny-1, 4]) + ρ[1, 2:ny-1] * U / 6.0
@. f[1, 2:ny-1, 5] = f[1, 2:ny-1, 7] - tmp
@. f[1, 2:ny-1, 8] = f[1, 2:ny-1, 6] + tmp
u[1, 2:ny-1] .= U
v[1, 2:ny-1] .= 0.0

@views @. f[nx, :, 3] = f[nx-1, :, 3]
@views @. f[nx, :, 6] = f[nx-1, :, 6]
@views @. f[nx, :, 7] = f[nx-1, :, 7]

@views f[:, 1, 2] .= f[:, 1, 4]
@views f[:, 1, 5] .= f[:, 1, 7]
@views f[:, 1, 6] .= f[:, 1, 8]
u[:, 1] .= 0.0
v[:, 1] .= 0.0

@views @. f[:, ny, 4] = f[:, ny, 2]
copy!(f[:, ny, 8], f[:, ny, 6])
copy!(f[:, ny, 7], @views f[:, ny, 5])
u[:, ny] .= 0.0
v[:, ny] .= 0.0

nothing
end

boundaryCondition0!(nx, ny, u, v, ρ, U, f);
boundaryCondition1!(nx, ny, u, v, ρ, U, f);
boundaryCondition2!(nx, ny, u, v, ρ, U, f);