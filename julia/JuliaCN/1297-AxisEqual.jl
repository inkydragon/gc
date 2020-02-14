# Plot output size.jl

using Plots
pyplot()

xs = [string("x", i) for i = 1:10]
ys = [string("y", i) for i = 1:4]
z = float((1:4) * reshape(1:10, 1, :))
heatmap(xs, ys, z, aspect_ratio=:equal, size=(300,100))

png("Plot output size")