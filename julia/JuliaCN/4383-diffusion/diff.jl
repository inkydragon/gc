using VectorizedRoutines
using FFTW
using CUDA
using BenchmarkTools

const USE_CUDA = true

const Arr3{T} = Array{T, 3}
const cmA3{T} = Array{Complex{T}, 3}
const cuA3{T} = CuArray{Complex{T}, 3}

"""计算参数（不可变）

若要修改某些参数则应使用

    mutable struct

"""
struct Params{T}
    # 迭代次数
    iter_times :: Int64
    # 各方向维度
    dim :: NTuple{3, Int64}

    M       :: T
    # not use
    v_gb    :: T
    δx      :: T
    δt      :: T
    l_gb    :: T
    σ_gb    :: T

    k2 :: Arr3{T}
    f_def :: Arr3{T}
end
Broadcast.broadcastable(p::Params) = Ref(p)

struct TmpVar{T}
    re :: Arr3{T}
    fft :: cmA3{T}
    cu :: cuA3{T}

    TmpVar(arr::Arr3{T}) where {T <: Real} =
        new{T}(arr, complex(arr), CuArray{Complex{T}}(arr))
end

"""存放变量

使用 SoA (Struct of Array)
"""
struct Var{T}
    rex   :: TmpVar{T}
    def   :: TmpVar{T}
    tmp   :: TmpVar{T}

    sumetasqu   :: TmpVar{T}
    f_def_force :: TmpVar{T}

    function Var(
            η_rex::Arr3{T}, η_def::Arr3{T}, 
            sumetasqu::Arr3{T}, f_def_force::Arr3{T}
        ) where {T <: Real}
        new{T}(
            TmpVar(η_rex), TmpVar(η_def),
            TmpVar(similar(η_rex)),
            TmpVar(sumetasqu), TmpVar(f_def_force)
        )
    end
end

function f_def_field(itype, dim, δx)
    nx, ny, nz = dim
    f_def = zeros(dim)

    if itype == 1
        f_def = @. f_def + 0.05
    elseif itype == 2
        angle1, λ_1, A_1, C_1 = + π / 12, 256 * δx, 0.05, 0.0
        angle2, λ_2, A_2, C_2 = - π / 12, 64  * δx, 0.05, 0.0
        xx = δx .* (1:ny)'
        f_def1 = zeros(dim)
        f_def2 = zeros(dim)
        for i in 1:nx, j in 1:ny
            f_def1[i,j,1] =  A_1 * (1 + sin(2π * (xx[i]/λ_1 - xx[j]/λ_2))) + C_1
            f_def2[i,j,1] =  A_2 * (1 + sin(2π * (xx[i]/λ_1 + xx[j]/λ_2))) + C_2
        end
        for i in 1:nx, j in 1:ny, k in 1:nz
            f_def[i,j,k] = max(f_def1[i,j,k], f_def2[i,j,k])
        end
    end
    
    f_def
end


"""初始化参数

+ iter_times: 迭代次数
+ dim: 空间维度
"""
function init_params(iter_times = 100, dim = (512, 512, 1))
    FFTW.set_num_threads(4)
    n    = iter_times
    nx, ny, nz = dim
    M    = 1.
    v_gb = 1.
    δx   = 1.
    δt   = 0.05
    l_gb = sqrt(9.6) * δx
    σ_gb = 0.32

    f_def = f_def_field(2, dim, δx)
    f_def_force = f_def

    η_rex = zeros(dim)
    η_rex[1:5, :, :] .= 1.
    η_def = @. 1. - η_rex
    sumetasqu = @. η_rex^2 + η_def^2
    ϕ_def = @. η_def^2 / sumetasqu
    f_def_force  = @. f_def_force * ϕ_def
    g   = @. 2π / nx / δx * [ 0:nx / 2; -nx / 2 + 1:-1 ]
    gg  = @. 2π / ny / δx * [ 0:ny / 2; -ny / 2 + 1:-1 ]
    ggg = @. 2π / nz / δx * [ 0:nz / 2; -nz / 2 + 1:-1 ]
    g1, g2, g3 = Matlab.meshgrid(g, gg, ggg)
    k2 = @. g1^2 + g2^2 + g3^2

    (
        Var(η_rex, η_def, sumetasqu, f_def_force),
        Params{Float64}(iter_times, dim, M, v_gb, δx,δt, l_gb,σ_gb, k2, f_def)
    )
end



#= 主要的计算函数 =#
help_kernel1(η1::T, η2::T, 
    sumetasqu::T, f_def_force::T, 
    p::Params
) where {T <: Real} =
    -4/3 * p.M / p.l_gb * 
    (6 * p.σ_gb/p.l_gb * (η1^3 - η1 + 3*η1*η2^2) - 
     2 * η1 * η2^2 / sumetasqu^2 * f_def_force)

"仅修改 tmp，其余变量不变"
help_kernel1!(tmp::cmA3{T},
    η1::Arr3{T}, η2::Arr3{T},
    sumetasqu::Arr3{T}, f_def_force::Arr3{T},
    p::Params{T},
) where {T<:Real} =
    @. tmp = help_kernel1(η1, η2, sumetasqu, f_def_force, p)

help_kernel2(tmp::T, cη1::T, cη2::T, k2::Real, p::Params) where {T <: Complex} =
    cη1 + p.δt * (-p.M * p.σ_gb * k2 * cη2 + tmp)

"仅修改 cη1，其余变量不变"
help_kernel2!(cη1::cmA3{T}, 
    cη2::cmA3{T}, tmp::cmA3{T},
    p::Params,
) where {T<:Real} =
    @. cη1 = help_kernel2(tmp, cη1, cη2, p.k2, p)

"复制 src 的实数部分到 des"
copyre!(des::Arr3{T}, src::cmA3{T}) where {T<:Real} =
    map!(real, des, src)
clearim!(arr::cmA3{T}) where {T<:Real} =
    @. arr = complex(real(arr))

"更新 η1，tmp 用作临时变量"
function help_kernel0!(::cmA3{T},
        η1::TmpVar{T}, η2::TmpVar{T},
        v::Var{T}, p::Params{T},
    ) where {T<:Real}
    # 先计算 fft 的参数，存放在 tmp.fft。然后计算 fft
    help_kernel1!(v.tmp.fft, η1.re, η2.re, v.sumetasqu.re, v.f_def_force.re, p)
    fft!(v.tmp.fft)

    # 先计算函数参数，存放在 η1.fft 中
    # 然后计算 ifft
    # 最后将 η1.fft 实部复制到 η1.re
    # 此时使用
    help_kernel2!(η1.fft, η2.fft, v.tmp.fft, p)
    ifft!(η1.fft)
    copyre!(η1.re, η1.fft) # 保证 fft/re 实部相同
    clearim!(η1.fft)
end

function help_kernel0!(::cuA3{T},
        η1::TmpVar{T}, η2::TmpVar{T},
        v::Var{T}, p::Params{T},
    ) where {T<:Real}
    # 先计算 fft 的参数，存放在 tmp.fft。然后计算 fft
    help_kernel1!(v.tmp.fft, η1.re, η2.re, v.sumetasqu.re, v.f_def_force.re, p)
    copyto!(v.tmp.cu, v.tmp.fft)
    fft!(v.tmp.cu)
    copyto!(v.tmp.fft, v.tmp.cu)

    # 先计算函数参数，存放在 η1.fft 中
    # 然后计算 ifft
    # 最后将 η1.fft 实部复制到 η1.re
    # 此时使用
    help_kernel2!(η1.fft, η2.fft, v.tmp.fft, p)
    copyto!(η1.cu, η1.fft)
    ifft!(η1.cu)
    copyto!(η1.fft, η1.cu)
    copyre!(η1.re, η1.fft) # 保证 fft/re 实部相同
    clearim!(η1.fft)
    copyto!(η1.cu, η1.fft)
end

"for 循环中的主体函数"
function main_kernel!(v::Var, p::Params, i::Int64)
    # 更新 rex/def.fft
    @static if USE_CUDA
        fft!(v.rex.cu)
        fft!(v.def.cu)
        copyto!(v.rex.fft, v.rex.cu)
        copyto!(v.def.fft, v.def.cu)
    
        # 分别更新 rex/def
        help_kernel0!(v.tmp.cu, v.rex, v.def, v, p)
        help_kernel0!(v.tmp.cu, v.def, v.rex, v, p)
    else
        # 函数假定此时 rex.fft 与 rex.re 数值相同，仅类型不同
        # @assert v.rex.fft==complex(v.rex.re) "[$i] rex.fft!=complex(rex.re)"
        # @assert v.def.fft==complex(v.def.re) "[$i] rex.fft!=complex(rex.re)"
        fft!(v.rex.fft)
        fft!(v.def.fft)
    
        # 分别更新 rex/def
        help_kernel0!(v.tmp.fft, v.rex, v.def, v, p)
        help_kernel0!(v.tmp.fft, v.def, v.rex, v, p)
    end

    # 更新 sumetasqu/f_def_force
    @. v.sumetasqu.re = v.rex.re^2 + v.def.re^2
    @. v.f_def_force.re = p.f_def * (v.def.re^2 / v.sumetasqu.re)
end

"主函数"
function main(iter_times = 100, dim = (512, 512, 1))
    v, p = init_params(iter_times, dim)

    for i in 1:p.iter_times
        main_kernel!(v, p, i)
    end

    v
end

# 运行主函数
@btime main(100, (1024, 1024, 1))
# main()