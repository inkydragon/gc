using Plots
gr()
m = 50
n = 14
X = 1:m
Y = reshape([i+0.01*j for i in 1:m for j in 1:n],m,n)
S = reshape([sin(j/3)*5 for i in 1:m for j in 1:n],m,n)
# Y = [i+0.01*j for i = 1:m, j = 1:n]
# S = [sin(j/3) for i = 1:m, j = 1:n]

fig = plot(X,Y,lw=2)
# for i in 1:m
#     scatter!(fig, 
#         [i],
#         Y[i,:]',
#         ms=S[i,:]',
#         color=:red,
#         markerstrokewidth=0
#     )
# end

scatter!(fig, 
    X,
    Y,
    ms=S,
    color=:red,
    markerstrokewidth=0
)

fig