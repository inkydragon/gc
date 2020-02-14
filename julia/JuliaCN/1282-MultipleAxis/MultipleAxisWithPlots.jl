using Plots
pyplot()

# 产生画图用数据
C = collect(0:10:100)
degC2K = x -> x + 273.15 # 摄氏度转开尔文
K2degC = x -> x - 273.15
K = degC2K.(C)
x = 10^4 ./ K
y = C.*rand(length(C))

# 计算坐标轴范围，对齐坐标轴
xlims1 = (min(K...), max(K...))
xlims2 = K2degC.(xlims1)

# 1-正常画图
p1 = plot(
    x, y, 
    xlabel = "1/Kelvin",
    xlims = xlims1, # 建议保留: 用于对齐坐标轴
)

# 2-暴力画坐标轴
# 实际上是另外画了一张图，但只显示 x 轴
p2 = plot(
    # K, zeros(length(K));
    # legend = false,
    # # 以上两句和下面一句二选一，效果一致
    # # 用于自动调整坐标轴范围
    # # 可同时工作
    xlims = xlims2, # 限定坐标轴范围
    axis = :x, # 只显示 x 轴
    xlabel = "deg-C", # x 轴说明文字
    grid = false, # 不显示网格线
)

# 3-纵向排列两张图
plot(
    p1, p2, # 放置两张图
    layout = grid(
        2, 1, # 布局为 两行一列
        heights = [0.99, 0.01] 
        # 这里可以调两个坐标轴的相对大小，相当于调整间距
        # 两个数之和*必须*为 1
        # heights = [0.5, 0.5]      # 超大间距
        # heights = [0.99, 0.01]    # 最小间距
    )
) # ref: [Layouts - Plots](https://docs.juliaplots.org/latest/layouts/#simple-layouts)
