#= 
    Lattice Boltzmann Method —— LBM
    Poiseuille flow
    
方程假设（LBGK 模型）
+ 流体不可压 / 密度变化不大：ρ = ρ0
+ 低马赫数流动：Ma <= 0.3

ref
- [Julia内存分配随着循环的进行越来越大](https://discourse.juliacn.com/t/topic/2763?u=woclass)
- [LBM 相变传热与流体流动数值分析13](https://wenku.baidu.com/view/05c4f88a71fe910ef12df8b0.html)
=#
# using ShiftedArrays
# 6.637 s (3004 allocations: 137.50 MiB)

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


# TODO: 参数结构体化; 测试结构体+数组的性能

raw"""
    D2Q9{T<:AbstractFloat, S<:Integer}

LBGK 单松弛模型 / DnGb 不可压模型 / D2Q9 模型

## D2Q9 模型

二维离散，共 9 个离散速度方向。
    e6  e2  e5
      \  |  /
    e3  e0  e1
      /  |  \
    e7  e4  e8

## 参数说明

### 默认模型常量
+ `D::S = 2` 空间维数
+ `Q::S = 9` 离散速度个数
+ `ex::Vector{S} = [1, 0,-1, 0,  1,-1,-1, 1,  0]` 水平速度分量
+ `ey::Vector{S} = [0, 1, 0,-1,  1, 1,-1,-1,  0]` 垂直速度分量
+ `w::Array{T, 2} = [1/9,  1/9,  1/9,  1/9, 1/36, 1/36, 1/36, 1/36, 4/9]` 权值参数

### 离散化参数


### 流动状态、物性参数

"""
struct D2Q9{T<:AbstractFloat, S<:Integer}
    #= 常量定义 =#
    "【常量】空间维数"
    D::S
    "【常量】离散速度个数"
    Q::S
    # "【常量】速度矢量"
    # e::Array{S, 2}
    "【常量】水平速度分量"
    ex::Vector{S}
    "【常量】垂直速度分量"
    ey::Vector{S}
    "【常量】权值参数"
    w::Vector{T}
    
    #= 离散化参数 =#
    nx::S # 水平方向格子数
    ny::S # 竖直方向格子数
    is_wall::BitArray{2}
    # "水平方向格子长度"
    # δx::T
    # "垂直方向格子长度"
    # δy::T
    # "时间步长"
    # δt::T
    # "格子声速。`c = δx/δt`"
    # c::T
    "C_s 平方的倒数。D2Q9 模型中 `δt==δx` 时为 3"
    inv_cs2::T # cₛ = c / sqrt(3); inv_cs2 = 1 / (cₛ^2)
    
    #= 流动状态、物性参数 =#
    U::T # 内部流速
    # "雷诺数"
    # Re::T
    # "运动粘度 `ν = cₛ^2 * ( τ-0.5 ) * δt`"
    # ν::T
    # "松弛时间"
    # τ::T
    "松弛频率。松弛时间的倒数。`ω = 1/τ`"
    ω::T
    "初始密度"
    ρ0::T

    "收敛要求。默认为：ε=1.0e-6"
    ε::T #1.0e-6
    
    # 内部构造函数
    function D2Q9{T, S}(
        nx::S, ny::S, is_wall::BitArray{2}, inv_cs2::T, 
        U::T, ω::T, ρ0::T,
        ε::T
    ) where {T<:AbstractFloat, S<:Integer}
        @doc "velocity components in horizontal direction" E_X
        @doc "velocity components in vertical direction" E_Y
        @doc "weight parameters" WEIGHT
        # i    1  2  3  4   5  6  7  8   0
        E_X = [1, 0,-1, 0,  1,-1,-1, 1,  0]
        E_Y = [0, 1, 0,-1,  1, 1,-1,-1,  0]
        WEIGHT = [ # 权值参数
            1/9,  1/9,  1/9,  1/9,  # 1~4
            1/36, 1/36, 1/36, 1/36, # 5~8
            4/9 # 0
        ]
        
        new{T, S}(
            2, 9, E_X, E_Y, WEIGHT, # 常量定义
            nx, ny, is_wall, inv_cs2, # 离散化参数
            U, ω, ρ0, # 流动状态、物性参数
            ε # 收敛要求
        )
    end
end
D2Q9{T, S}(
  ; nx::S, ny::S, is_wall::BitArray{2}, 
    U::T, ω::T, ρ0::T,
    inv_cs2::T=3.0, ε::T=1e-6
) where {T<:AbstractFloat, S<:Integer} =
    D2Q9{T, S}(nx, ny, is_wall, inv_cs2, U, ω, ρ0, ε)


function mainFlow(iterStepMax=50)
#=
    常量定义
=#
### 数据类型定义
FloatType = Float64 # 可改成其他浮点类型 (16/32/64/BigFloat)
D1Vector = Vector{FloatType}
D2Array = Array{FloatType, 2}
D3Array = Array{FloatType, 3}

### 模型大小
nx = 1200   # 水平方向格子数
ny = 600    # 竖直方向格子数
is_wall = falses(nx, ny)
is_wall[:,   1] .= true
is_wall[:, end] .= true
U = 0.1     # 内部流速

### 常量计算
δx = 1.0 # horizontal lattice length
δy = 1.0 # vertical lattice length
δt = δx  # δt = 1.0
# c  = δx / δt # lattice sound speed, 格子声速
# cₛ = c / sqrt(3)
# inv_cs2 = 1 / (cₛ^2)
@doc "C_s 平方的倒数。D2Q9 模型中 `δt==δx` 时为 3" ->
inv_cs2 = 3.0

lx = δx * nx # horizontal domain length
ly = δy * ny # vertical domain length
Re = 1000.0 # Reynoldz number
ν = U * ly / Re # kinematic viscousity
τ = 3.0ν + 0.5 # relaxation time
ω = 1.0 / τ # relaxation frequency

ε  = 1.0e-6 #convergence requirement

"模型参数集"
params = D2Q9{FloatType, Int64}(
    nx=nx, ny=ny, is_wall=is_wall, U=U, ω=ω,
    ρ0 = 1.0, # 初始密度
    inv_cs2=inv_cs2, ε=ε
)

println("Re = $Re, τ = $τ")


#=
    预分配内存
=#
### _tmp_* 临时变量
_tmp_arr = D2Array(undef, nx, ny)    # 大小为 (nx, ny) 的临时数组
_tmp_f   = D3Array(undef, nx, ny, params.Q) # 大小为 (nx, ny, Q) 的临时数组

### 物理量分配内存 + 初始化
ρ   =  ones(FloatType, nx, ny) # initial density
u   = zeros(FloatType, nx, ny) # horizontal velocity component
v   = zeros(FloatType, nx, ny) # vertical velocity component
u0  = zeros(FloatType, nx, ny) # horizontal velocity component before iteration
v0  = zeros(FloatType, nx, ny) # vertical velocity component befre iteration
uv  = zeros(FloatType, nx, ny) # resultant velocity
f   = zeros(FloatType, nx, ny, params.Q) # distribution function
# feq = zeros(FloatType, nx, ny, params.Q) # equilibrium distribution function, 平衡分布函数


init!(f, ρ, u, v, params)
for iterStep = 1:iterStepMax
    collision!(f, ρ, u, v, params)
    streaming!(f, _tmp_f, params)
    boundaryCondition!(f, u, v, ρ, params)
    macroQuantity!(ρ, u0, v0, u, v, uv, f, params)
    converged(_tmp_arr, u, v, u0, v0, params) && break
    # rel_err = relative_error(_tmp_arr, u, v, u0, v0) 
    # if rel_err <= params.ε
    #     break
    # else
    #     println("[rel err] $rel_err")
    # end
end

# params, u, v
end # end of mainFlow


"""
    init!(f, ρ, u, v, params)

初始化 `u, ρ, f`
"""
function init!(f, ρ, u, v, params)
@. u[1, 2:params.ny-1] = params.U # y=1, end 为壁面
@. ρ = params.ρ0

# 无需初始化，第一次碰撞 f=0，则 f=feq 相当于初始化
# for k=1:params.Q, j=1:params.ny, i=1:params.nx
#     # params.is_wall[i, j] && continue
#     @inbounds f[i,j,k] = feq(params.w[k], ρ[i,j], params.ex[k], params.ey[k], u[i,j], v[i,j])
# end
end

"""
    collision!(f, ρ, u, v, params)
    collision!(
        f::Array{T,3}, ρ::Array{T,2}, 
        u::Array{T,2}, v::Array{T,2},
        params::D2Q9{T,S}
    ) where { T<:AbstractFloat, S<:Integer }

碰撞及迁移

`f(x+eδt, t+δt) = f(x,t) - 1/τ * (f(x,t) - feq(x,t))`
"""
function collision!(
    f::Array{T,3}, ρ::Array{T,2}, 
    u::Array{T,2}, v::Array{T,2},
    params::D2Q9{T,S}
) where { T<:AbstractFloat, S<:Integer }
for k = 1:params.Q, j = 1:params.ny, i = 1:params.nx
    # params.is_wall[i, j] && continue
    @inbounds f[i, j, k] = collision(
        f[i, j, k], ρ[i, j], u[i, j], v[i, j], 
        params.ω, params.w[k], params.ex[k], params.ey[k]
    )
end
end # end of collision

"计算一次碰撞，所有参数均为非集合类型。"
@inline function collision(
    f::T, ρ::T, u::T, v::T, 
    ω::T, w::T, 
    ex::S, ey::S, 
) where { T<:AbstractFloat, S<:Integer }
    # f(x+eδt, t+δt) = f(x,t) - 1/τ * (f(x,t) - feq(x,t))
    # (1 - ω) * f + ω * feq(x); 【 ω = 1/τ 】
    (1.0 - ω) * f + ω * feq(u, v, ex, ey, w, ρ)
end

"""
    feq(u, v, ex, ey, w, ρ)
    feq(
        u::T, v::T, 
        ex::S, ey::S, 
        w::T, ρ::T, 
        ; inv_cs2::Float64=3.0
    ) where { T<:AbstractFloat, S<:Integer }

计算平衡分布函数 `f^eq(x)`。

                            e*u    (e*u)^2     u^2
    feq(x) = w * ρ * [ 1 + ————— + ——————— - ——————— ]
                           c_s^2   2*c_s^4   2*c_s^2

关键参数：
+ `w` 权值系数
+ `c_s` 格子声速
"""
@inline function feq(
    u::T, v::T, 
    ex::S, ey::S, 
    w::T, ρ::T, 
    ; inv_cs2::T=3.0
) where { T<:AbstractFloat, S<:Integer }
    eu = u*ex + v*ey
    uv = u^2 + v^2

    # w * ρ * (1 + eu/cₛ^2 + eu^2/2/cₛ^4 - uv/2/cₛ^2)
    # w*ρ*(1 + eu*inv_cs2 + eu*inv_cs2^2/2 - uv*inv_cs2/2)
    w * ρ * (1 + 3.0*eu + 4.5*eu^2 - 1.5*uv)
end


"""
    streaming!(f, _tmp_f, params)
    streaming!(
        f, _tmp_f,
        params::D2Q9{T,S}
    ) where { T<:AbstractFloat, S<:Integer }

"""
function streaming!(
    f::Array{T,3}, _tmp_f::Array{T,3},
    params::D2Q9{T,S}
) where { T<:AbstractFloat, S<:Integer }
copy!(_tmp_f, f)
for k = 1:params.Q
    # f[:, :, k] .= ShiftedArrays.circshift(@view(_tmp_f[:, :, k]), (ex[k], ey[k]))
    # 6.504 s (3566 allocations: 186.95 MiB)
    @views circshift!(f[:, :, k], _tmp_f[:, :, k], (params.ex[k], params.ey[k]))
    # 5.888 s (3116 allocations: 186.93 MiB)
end
end # end of streaming


"""
    boundaryCondition!(f, u, v, ρ, params)
    boundaryCondition!(
        f::Array{T,3}, u::Array{T,2},  v::Array{T,2},
        ρ::Array{T,2},     
        params::D2Q9{T,S}
    ) where { T<:AbstractFloat, S<:Integer }

边界条件。
"""
function boundaryCondition!(
    f::Array{T,3}, u::Array{T,2},  v::Array{T,2},
    ρ::Array{T,2},     
    params::D2Q9{T,S}
) where { T<:AbstractFloat, S<:Integer }
p = params

#= 左右边界（出入口边界）
左边界（入口）—— ZOU&HE 速度边界
右边界（出口）—— 

ref- [LBM相变传热与流体流动数值分析14](https://wenku.baidu.com/view/b663f0cfaa00b52acfc7cab0)
=#

# - [lbxflow/boundary.jl at master · grasingerm/lbxflow](https://github.com/grasingerm/lbxflow/blob/master/inc/boundary.jl#L520)
# 2:params.ny-1 不考虑边界
for j = 2:(params.ny-1)
    #left
    @inbounds f[1, j, 1] = f[1, j, 3] + ρ[1, j] * p.U * 2.0 / 3.0
    temp = 0.5 * (f[1, j, 2] - f[1, j, 4]) + ρ[1, j] * p.U / 6.0
    @inbounds f[1, j, 5] = f[1, j, 7] - temp
    @inbounds f[1, j, 8] = f[1, j, 6] + temp
    #right
    @inbounds f[p.nx, j, 3] = f[p.nx-1, j, 3]
    @inbounds f[p.nx, j, 6] = f[p.nx-1, j, 6]
    @inbounds f[p.nx, j, 7] = f[p.nx-1, j, 7]
end
@. u[1, 2:(params.ny-1)] = p.U
@. v[1, 2:(params.ny-1)] = 0.0

#= 上下边界 —— 标准反弹格式
静止、无滑移壁面常用格式
+ 标准反弹
+ 半步长反弹
+ 修正反弹
=#
for i = 1:params.nx
    # bottom `y = 1`
    @inbounds f[i, 1, 2] = f[i, 1, 4]
    @inbounds f[i, 1, 5] = f[i, 1, 7]
    @inbounds f[i, 1, 6] = f[i, 1, 8]
    # top `y = params.ny==end`
    @inbounds f[i, end, 4] = f[i, end, 2]
    @inbounds f[i, end, 7] = f[i, end, 5]
    @inbounds f[i, end, 8] = f[i, end, 6]
end
@. u[:, 1] = 0.0
@. v[:, 1] = 0.0
@. u[:, end] = 0.0
@. v[:, end] = 0.0
end # end of boundaryCondition!


"""
    macroQuantity!(ρ, u0, v0, u, v, uv, f, params)
    macroQuantity!(ρ, u0, v0, u, v, uv,
        f, params::D2Q9{T,S}
    ) where { T<:AbstractFloat, S<:Integer }

计算宏观物理量。

+ 密度: `ρ = sum(f)`
+ 速度: `u = sum(f*e) / ρ`
+ 压力: `p = cₛ * ρ`
"""
function macroQuantity!(
    ρ::Array{T,2}, u0::Array{T,2}, v0::Array{T,2}, 
    u::Array{T,2},  v::Array{T,2}, uv::Array{T,2},
    f::Array{T,3}, params::D2Q9{T,S}
) where { T<:AbstractFloat, S<:Integer }
sum!(ρ, f)
copy!(u0, u)
copy!(v0, v)

for j=1:params.ny, i=1:params.nx
    # params.is_wall[i, j] && continue
    uSum = 0.0
    vSum = 0.0
    for k = 1:params.Q
        @inbounds uSum += f[i, j, k] * params.ex[k]
        @inbounds vSum += f[i, j, k] * params.ey[k]
    end
    @inbounds u[i, j] = uSum / ρ[i, j]
    @inbounds v[i, j] = vSum / ρ[i, j]
end
@. uv = sqrt(u^2 + v^2)
# ρ, u, v, uv
end # end of macroQuantity


"""
    converged(_tmp_arr, u, v, u0, v0, params)
    converged(
        _tmp_arr::Array{T,2}, 
        u::Array{T,2}, v::Array{T,2}, 
        u0::Array{T,2}, v0::Array{T,2}, 
        params::D2Q9{T,S}
    ) where { T<:AbstractFloat, S<:Integer }

计算相对误差，判断是否达到收敛要求。

                 (u-u0)^2 + (v-v0)^2
    rel_err^2 = --------------------- = [0, 1)
                   u^2 + v^2 + eps
"""
converged(
    _tmp_arr::Array{T,2}, 
    u::Array{T,2}, v::Array{T,2}, 
    u0::Array{T,2}, v0::Array{T,2}, 
    params::D2Q9{T,S}
) where { T<:AbstractFloat, S<:Integer } =
    relative_error(_tmp_arr, u, v, u0, v0) <= params.ε

"计算相对误差"
function relative_error(
    _tmp_arr::Array{T,2}, 
    u::Array{T,2}, v::Array{T,2}, 
    u0::Array{T,2}, v0::Array{T,2}
) where { T<:AbstractFloat }
    @. _tmp_arr = (u-u0)^2 + (v-v0)^2
    temp1 = sum(_tmp_arr)
    @. _tmp_arr = u^2 + v^2
    temp2 = sum(_tmp_arr)
    
    # eps(Float64) == 2.220446049250313e-16
    sqrt( temp1 / (temp2 + 1e-16) )
end # end of relative_error!


# mainFlow(50)
using BenchmarkTools
@btime mainFlow(50);

# nx, ny, U, V = mainFlow(50)
# 
# function mgrid(nx, ny)
#     reshape([y for y=1:ny for x=1:nx], (nx, ny)),
#     reshape([x for y=1:ny for x=1:nx], (nx, ny))
# end
# 
# using PyPlot
# X, Y = mgrid(nx, ny)
# streamplot(X, Y, U, V)
# gcf()
