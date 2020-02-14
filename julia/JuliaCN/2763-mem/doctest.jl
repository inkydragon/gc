struct D2Q9
    nx
    ny
    U
    H
end

model = D2Q9(0,0,0,0)
# ### 模型大小
@doc "lattice number in horizontal direction" model.nx
@doc "lattice number in vertical direction" model.ny
@doc "inlet velocity" model.U
model.nx = 1200   # 水平方向格子数
model.ny = 600    # 竖直方向格子数
model.U = 0.1     # 内部流速
model.H = 5       # 流道高度


@doc "C_s 平方的倒数。D2Q9 中 `δt==δx` 时为 3" ->
inv_cs2 = 3

""" 计算宏观物理量

- [x] 密度: `ρ = sum(f)`
- [ ] 速度: `u = sum(f*e) / ρ`
+ 压力: `p = cₛ * ρ`
+ 运动粘度: `ν = cₛ^2 * ( τ-0.5 ) * δt`
"""
macroQuantity() = nothing

@doc raw"""
    const Q = 9 :: Int64

离散速度的个数，共 9 个方向。

## D2Q9 模型
    C6  C2  C5
      \  |  /
    C3  C0  C1
      /  |  \
    C7  C4  C8

### DnQb
+ `n` —— 空间维数
+ `b` —— 离散速度个数
""" ->
Q = 9 # D2Q9


@doc raw"""
    ff(x[, y])

asdfsaf
asdfsa
""" ff
ff2(x) = x
ff(x) = x

@doc raw"""
    bar(x[, y])

asdfsaf
asdfsa
"""
f(x) = x

@doc """
asdfafa


dsfasf
""" y

y(x) = x


"""
    bar(x[, y])

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
z(x) = x

@doc """
    bar(x[, y])

Compute the Bar index between `x` and `y`. If `y` is missing, compute
the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
""" z2

z2(x) = x