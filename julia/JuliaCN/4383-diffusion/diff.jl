using VectorizedRoutines
using FFTW
using CUDA
using BenchmarkTools

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

"""存放变量

使用 SoA (Struct of Array)
"""
struct Var{T}
    η_rex   :: Arr3{T}
    cη_rex  :: cmA3{T}
    cuη_rex :: cuA3{T}

    η_def   :: Arr3{T}
    cη_def  :: cmA3{T}
    cuη_def :: cuA3{T}

    tmp     :: cmA3{T}
    cu_tmp  :: cuA3{T}

    sumetasqu   :: Arr3{T}
    f_def_force :: Arr3{T}

    function Var(
            η_rex::Arr3{T}, η_def::Arr3{T}, 
            sumetasqu::Arr3{T}, f_def_force::Arr3{T}
        ) where {T <: Real}
        dim = size(η_rex)
        new{T}(
            η_rex, complex(η_rex), CuArray{Complex{T}}(η_rex),
            η_def, complex(η_def), CuArray{Complex{T}}(η_def),
            zeros(Complex{T}, dim), CUDA.zeros(Complex{T}, dim),
            sumetasqu, f_def_force
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

help_kernel1!(tmp::cmA3{T},
    η1::Arr3{T}, η2::Arr3{T},
    sumetasqu::Arr3{T}, f_def_force::Arr3{T},
    p::Params{T},
) where {T<:Real} =
    @. tmp = help_kernel1(η1, η2, sumetasqu, f_def_force, p)

help_kernel2(tmp::T, cη1::T, cη2::T, k2::Real, p::Params) where {T <: Complex} =
    cη1 + p.δt * (-p.M * p.σ_gb * k2 * cη2 + tmp)

help_kernel2!(tmp::Arr3{T},
    cη1::Arr3{T}, cη2::Arr3{T},
    p::Params,
) where {T<:Complex, N} =
    @. tmp = help_kernel2(tmp, cη1, cη2, p.k2, p)

"复制 src 的实数部分到 des"
copyre!(des::Arr3{T}, src::cmA3{T}) where {T<:Real, N} =
    map!(real, des, src)

function help_kernel0!(
        η1::Arr3{T}, cη1::cmA3{T},
        η2::Arr3{T}, cη2::cmA3{T},
        v::Var{T},
        p::Params{T},
    ) where {T<:Real}
    # 计算 tmp
    help_kernel1!(v.tmp, η1, η2, v.sumetasqu, v.f_def_force, p)
    fft!(v.tmp)

    # 计算 cη1 和 cη2 的 fft 
    fft!(cη1)
    fft!(cη2)

    # 计算 ifft, 复制实数部分到 η1, η2
    help_kernel2!(v.tmp, cη1, cη2, p)
    ifft!(v.tmp)
    copyre!(η1, cη1)
    copyre!(η2, cη2)
end

"for 循环中的主体函数"
function main_kernel!(v::Var, p::Params)
    help_kernel0!(v.η_rex, v.cη_rex, v.η_def, v.cη_def, v, p)
    help_kernel0!(v.η_def, v.cη_def, v.η_rex, v.cη_rex, v, p)

    @. v.sumetasqu = v.η_rex^2 + v.η_def^2
    @. v.f_def_force = p.f_def * (v.η_def^2 / v.sumetasqu)
end

"主函数"
function main(iter_times = 100, dim = (512, 512, 1))
    v, p = init_params(iter_times, dim)

    for i in 1:p.iter_times
        main_kernel!(v, p)
    end

    v
end

# 运行主函数
@btime main(100, (1024, 1024, 1))
# main()