
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
    # "流道高度"
    # H::T
    # "雷诺数"
    # Re::T
    # "运动粘度"
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
        nx::S, ny::S, inv_cs2::T, 
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
            nx, ny, inv_cs2, # 离散化参数
            U, ω, ρ0, # 流动状态、物性参数
            ε # 收敛要求
        )
    end
end

D2Q9(
  ; nx::S, ny::S, 
    U::T, ω::T, ρ0::T,
    inv_cs2::T=3.0, ε::T=1e-6
) where {T<:AbstractFloat, S<:Integer} =
    D2Q9{T,S}(nx, ny, inv_cs2, U, ω, ρ0, ε)

d1 = D2Q9(nx=10, ny=5, U=1.0, ω=1.0, ρ0=1.0)
d2 = D2Q9(nx=10, ny=5, U=1.0, ω=1.0, ρ0=1.0, inv_cs2=3.0, ε=1e-6)
d3 = D2Q9{Float64, Int64}(10,5,3.0, 1.0,1.0,1.0, 1e-6)

@assert typeof(d1)==typeof(d2) && typeof(d1)==typeof(d3)
@assert string(d1)==string(d2) && string(d1)==string(d3)
