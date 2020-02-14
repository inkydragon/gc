using Makie

nx = 12
ny = 6

x = 1:nx
y = 1:ny
# z = x .* exp.(-x .^ 2 .- (y') .^ 2)
# scene = contour(x, y, z, levels = 10, linewidth = 3)
function mgrid(nx, ny)
    reshape([y for y=1:ny for x=1:nx], (nx, ny)),
    reshape([x for y=1:ny for x=1:nx], (nx, ny))
end

u, v = mgrid(nx, ny)
arrows!(x, y, u, v, arrowsize = 0.05)
