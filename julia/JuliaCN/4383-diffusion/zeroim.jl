using BenchmarkTools

function zeroim(arr::Array{Complex{Float64},3})
    complex(real(arr))
end

function zeroim!(arr::Array{Complex{Float64},3})
    @. arr = complex(real(arr))
end

function zeroim!(res::Array{T, N}, arr::Array{T, N}) where {T<:Complex, N}
    map!(c->c.re+0im, res, arr)
end

function zeroim1!(res::Array{T, N}, arr::Array{T, N}) where {T<:Complex, N}
    map!(c->complex(real(c), 0.0), res, arr)
end

big_carr = zeros(ComplexF64, 10^4,10^3,3)
res = zeros(ComplexF64, 10^4,10^3,3)
#=
204.392 ms (4 allocations: 686.65 MiB)
  60.003 ms (0 allocations: 0 bytes)
  87.327 ms (0 allocations: 0 bytes)
  85.008 ms (0 allocations: 0 bytes)
=#

@btime zeroim($big_carr)
@btime zeroim!($big_carr)
@btime zeroim!($res, $big_carr)
@btime zeroim1!($res, $big_carr)