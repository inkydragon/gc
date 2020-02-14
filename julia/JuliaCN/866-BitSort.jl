# 如果要考虑最坏的情况，从二进制的角度进行考虑

# 不稳定的算法
# function partition!(v::AbstractVector, lo::Int, hi::Int, shift::Int64)
#     @inbounds while true
#         while lo <= hi && (v[lo] & shift) == 0; lo += 1; end;
#         while lo <= hi && (v[hi] & shift) != 0; hi -= 1; end;
#         lo >= hi && break
#         v[lo], v[hi] = v[hi], v[lo]
#         lo += 1; hi -= 1
#     end
#     return lo
# end

# 稳定的算法
function partition!(v::AbstractVector, lo::Int, hi::Int, shift::Int64)
    cur = lo
    @inbounds while lo <= hi
        if (v[lo] & shift) != 0
            j = max(cur, lo) + 1
            while j <= hi && (v[j] & shift) != 0; j += 1; end
            j > hi && return lo
            v[lo], v[j] = v[j], v[lo]
            cur = j
        end
        lo += 1
    end
    return lo
end


function BitSort!(v::AbstractVector, lo::Int, hi::Int, shift::Int64)
   if lo < hi && shift > 0
        j = partition!(v, lo, hi, shift)
        BitSort!(v, lo, j - 1, shift >> 1)
        BitSort!(v, j, hi, shift >> 1)
    end
    return v
end


function flp2(n::Int64)
    for i in (1, 2, 4, 8, 16, 32)
        n |= n >> i
    end
    n - (n >> 1)
end

function BitSort!(v::AbstractVector)
    shift = flp2(maximum(v))
    BitSort!(v, 1, length(v), shift)
end

using BenchmarkTools
number = 10^7
v = rand(1:number, number)
@btime BitSort!(v)
@assert issorted(v)
@btime BitSort!(v)
