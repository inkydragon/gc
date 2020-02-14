using Flux

model = Chain(
    Dense(2, 10, relu),
    Dense(10, 1)
)

X = rand(2, 100)
Y = []
for r in eachcol(X)
	if r[1] > r[2]
		push!(Y, 1.0)
	elseif r[1] == r[2]
		push!(Y, 0.5)
	else
		push!(Y, 0.0)
	end
end
data = [(X, Y)]

#目的是创建一个判断前后两个数大小的网络

loss(x, y) = Flux.mse(model(x), y)
ps = params(model)
opt = ADAM()
Flux.train!(loss, ps, data, opt)

function monitor(e)
    println("epoch $(lpad(e, 4)): loss = $(round(loss(X,Y).data; digits=4))")
end

for e in 0:1000
    Flux.train!(loss, params(model), [(X, Y)], opt)
    if e % 100 == 0; monitor(e) end
end

model([233; 666]) 

# 
# using Flux: Chain, Dense, params, crossentropy, onehotbatch, mse,
#             ADAMW, train!, softmax
# using Test
# 
# # Data preparation
# function func(x, y)
#     if x > y
#         return "gt"
#     elseif x < y
#         return "lt"
#     else
#         return "eq"
#     end
# end
# func(a::Array) = func.(a[1, :], a[2, :])
# 
# const LABELS = ["gt", "lt", "eq"];
# @test func([1 0 1; 0 1 1]) == LABELS
# 
# raw_x = rand(2, 100);
# raw_y = func(raw_x);
# 
# X = raw_x;
# Y = onehotbatch(raw_y, LABELS);
# 
# # Model
# m = Chain(Dense(2, 10), Dense(10, 3), softmax)
# loss(x, y) = mse(m(x), y)
# opt = ADAMW()
# 
# # Helpers
# deepbuzz(x, y) = LABELS[argmax(m([x; y]))]
# deepbuzz(a::Array) = deepbuzz.(a[1, :], a[2, :])
# 
# function monitor(e)
#     print("epoch $(lpad(e, 4)): loss = $(round(loss(X,Y).data; digits=4)) | ")
#     println(deepbuzz([1 0 1; 0 1 1]))
# end
# 
# # Training
# for e in 0:3000
#     train!(loss, params(m), [(X, Y)], opt)
#     if e % 100 == 0; monitor(e) end
# end
