# 1D有限元求解示例。(在0.6与1.0下均可运行)
# 节点编号为：0, 1, ..., n+1
# 0与n+1为边值，待求量只有1, 2, ..., n
# 所求BVP
# y'' = 4y
# y(0) = 1.
# y(1) = e^2

using Plots
gr()

function BVPFEM(inter, bv, n)  # inter为计算区间; bv为边值; n为步数

    a1 = inter[1]; a2 = inter[2]
    ya = bv[1];    yb = bv[2]
    h  = (a2-a1) / (n+1)

    alpha = (8. / 3.)*h + 2. / h
    beta  = 2. * h / 3. - 1. / h

    # 左端项系数矩
    A = zeros(n,n)
    for i in 1:n
        A[i,i] = alpha
    end
    for i in 2:n
        A[i-1,i] = beta
        A[i,i-1] = beta
    end

    # 变量t
    t = zeros(n+2)
    t = [a1+(i-1.)*h for i in 1:n+2]

    # 右端项
    B = zeros(n,1)
    B[1,1] = -ya*beta
    B[n,1] = -yb*beta
    c = zeros(n+2,1)
    c[1,1] = ya; c[n+2,1] = yb
    c[2:n+1,1] = A\B
    # println(c)  # 原方程的数值解
    c1 = exp.(2*t)  # 原方程的解析解
    # println(c1)

    return t, c, c1
end

n = 99  # n为待求量个数
t, c, c1 = BVPFEM([0. 1.], [1. exp.(2.0)], n)  # [0. 1.]为计算区间; [1. exp.(2.0)]为边界值

plot(t, c,
        markershape = :circle,
        markersize = 3,
        label="Numerical sol", legend = :topleft)
plot!(t, c1,
        linewidth = 2,
        label="Analytical sol")
# 程序有点小瑕疵。1. 数组t的下标为1:n+2，本来想变化到0:n+1(为了与理论推导时的下表一致)，却失败了。2. 还有想让两条曲线一条是实线，一条是虚线，也没成功。看论坛里哪位大牛把这两个问题搞一下。
