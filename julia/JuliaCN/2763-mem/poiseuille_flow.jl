
"""
    velocity_Analytical(y, H, L, ΔP, ν)
    velocity_Analytical(y::T, 
        H::T, L::T, ΔP::T, ν::T 
    ) where { T<:AbstractFloat }

Poiseuille flow 解析解。
"""
function velocity_Analytical(y::T, 
    H::T, L::T, ΔP::T, ν::T 
) where { T<:AbstractFloat }
    # analytical solution
    ΔP / (2*ν*L) * (y*H - y^2)
end
velocity_Analytical(y, H, L, ΔP, ν) = 
    velocity_Analytical(promote(y, H, L, ΔP, ν)...)

"func like numpy"
function mgrid(nx, ny)
    reshape([x for y=1:ny, x=1:nx], (ny, nx)),
    reshape([y for y=1:ny, x=1:nx], (ny, nx))
end

H  = 50
L  = 200
ΔP = 1.01 - 1.00
ν  = 1/6

nx = 200
ny = 50
X, Y = mgrid(nx, ny)
U = zeros(Float64, ny, nx)
V = zeros(Float64, ny, nx)


for j in 1:ny
    y = H * j/ny
    U[j, :] .= velocity_Analytical(y, H, L, ΔP, ν)
end


# using Makie
using PyPlot
quiver(X, Y, U, V)
# streamplot(X, Y, U, V)
gcf()
