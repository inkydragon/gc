# iteration

# 平方数列
struct Squares
    count::Int
end

Base.iterate(S::Squares, state=1) = state > S.count ? nothing : (state*state, state+1)
Base.eltype(::Type{Squares}) = Int
Base.length(S::Squares) = S.count
Base.sum(S::Squares) = (n = S.count; return n*(n+1)*(2n+1)÷6)
Base.iterate(rS::Iterators.Reverse{Squares}, state=rS.itr.count) = state < 1 ? nothing : (state*state, state-1)


# Fibonacci
struct Fibonacci{T<:Real} end
Fibonacci(d::DataType) = d<:Real ? Fibonacci{d}() : error("No Real type!")

Base.iterate(::Fibonacci{T}) where {T<:Real} = (zero(T), (one(T), one(T)))
Base.iterate(::Fibonacci{T}, state::Tuple{T, T}) where {T<:Real} = (state[1], (state[2], state[1] + state[2]))

# Hailstone
struct Hailstone
    count::Int64
end
function Base.iterate(h::Hailstone, state=h.count)
    if state == 1
        (1, 0)
    elseif state < 1
        nothing
    elseif iseven(state)
        (state, state ÷ 2)
    elseif isodd(state)
        (state, 3state + 1)
    end
end
Base.eltype(::Type{Hailstone}) = Int64

function Base.length(h::Hailstone)
    len = 0
    for _ in h
        len += 1
    end
    return len
end

function Base.show(io::IO, h::Hailstone)
    f5 = collect(Iterators.take(h, 5))
    print(io, "HailstoneSeq(", join(f5, ", "), "...)")
end

function ph(n::Int64)
    for i in Hailstone(n)
        print(i, ',')
    end
end