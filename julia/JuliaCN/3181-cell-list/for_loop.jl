using BenchmarkTools
# Point = Tuple{Float64, Float64}
# PointVec = Vector{Point}
PointVec = Array{Float64, 2}

function distance(arr::PointVec, idx::Int64, idy::Int64)
    (arr[idx, 1]-arr[idy, 1])^2 + (arr[idx, 2]-arr[idy, 2])^2
end

function for_loop(arr::PointVec, s::Float64)
    len, _ = size(arr)
    poi_pair = []
    for i = 1:len-1
        for j = i+1:len
            if distance(arr, i, j) < s
                push!(poi_pair, (i,j))
            end
        end
    end
    poi_pair
end

NumNod = 1000
Dim = 2
A = rand(NumNod,Dim)
s = 0.1;
b = for_loop(A,s)

# julia> A = rand(10_000, 2);
# julia> @btime b = for_loop($A,$s);
#   954.328 ms (11818429 allocations: 489.67 MiB)
# julia> @btime for_loop($A,$s);
#   887.003 ms (11818429 allocations: 489.67 MiB)