# Offset Reciprocal plot.jl
using Plots
pyplot()

# 产生画图用数据
C = collect(0:10:100) .+ 1
degC2K = x -> x + 273.15
K2degC = x -> x - 273.15
K = degC2K.(C)
x = 10^4 ./ K
y = C.*rand(length(C))

# 计算坐标轴范围，对齐坐标轴
xlim = (min(x...), max(x...))
Klim = (min(C...), max(C...))

p1 = plot(
    x, y, 
    xlabel = "1/Kelvin",
    xlims = xlim, # 用于对齐坐标轴
    xflip = true,
)
# ref:
# - [flip X-axis - Plots](https://docs.juliaplots.org/latest/examples/pyplot/#global)

# 2-暴力画坐标轴
p2 = plot(
    xlims = Klim, # 限定坐标轴范围
    axis = :x, # 只显示 x 轴
    # xscale = :log10, # 这句有点问题会报错
    xlabel = "deg-C", # x 轴说明文字
    grid = false, # 不显示网格线
)

# 3-纵向排列两张图
plot(
    p1, p2, # 放置两张图
    layout = grid(
        2, 1, # 布局为 两行一列
        heights = [0.99, 0.01] 
    )
)
