using BenchmarkTools
PointArr = Array{Float64, 2}
Point = Tuple{Int64,Int64}
PointVec = Vector{Point}

function frnn_main(arr::PointArr, s::Float64)
    nothing # mem count
    len, dim = size(arr)
    r = s / sqrt(dim)
    poi_pair = PointVec(undef,1)
    cell = poi_cell(arr, r)
    for key in keys(cell)
        inner_cell_pair!(poi_pair, cell, key)
        loop_neighbor!(poi_pair, cell, key, arr, s)
    end
    poi_pair
end

function poi_cell(arr::PointArr, r::Float64)
    nothing # mem count
    cell = Dict()

    cell_idx = map(x->Int(floor(x)), arr/r)
    tup_vec = [(x,y) for (x,y) in eachrow(cell_idx)] # 二维数组 变 一维元组的数组
    for (i, z) in enumerate(tup_vec)
        if z ∉ keys(cell)
            cell[z] = [i]
        else
            push!(cell[z], i)
        end
    end
    cell
end

function get_neighbor_cell(key::Point)
    nothing # mem count
    x, y = key
    nei_cell = Array{Point}(undef,8,1)
    nei_cell[1] = (x+1, y+1)
    nei_cell[2] = (x+1, y)
    nei_cell[3] = (x+1, y-1)
    nei_cell[4] = (x,   y+1)
    nei_cell[5] = (x,   y-1)
    nei_cell[6] = (x-1, y)
    nei_cell[7] = (x-1, y+1)
    nei_cell[8] = (x-1, y-1)
    nei_cell
end

function inner_cell_pair!(poi_pair::PointVec, cell::Dict, key::Point)
    nothing # mem count
    len = length(cell[key])
    if len < 2
        return poi_pair
    end

    for i = 1:len-1
        for j = (i+1):len
            push!(poi_pair, (cell[key][i], cell[key][j]))
        end
    end
    poi_pair
end

function loop_neighbor!(
    poi_pair::PointVec,
    cell::Dict,
    key::Point,
    arr::PointArr,
    s::Float64
)
    nothing # mem count
    nei_cell = get_neighbor_cell(key)
    for (idx, key1) in enumerate(nei_cell)
        if key1 ∈ keys(cell)
            find_pair!(poi_pair, cell, key, nei_cell, idx, arr, s)
        end
    end
    poi_pair
end

function distance(arr::PointArr, idx::Int64, idy::Int64)
    (arr[idx, 1]-arr[idy, 1])^2 + (arr[idx, 2]-arr[idy, 2])^2
end

function find_pair!(
    poi_pair::PointVec,
    cell::Dict,
    key::Point,
    nei_cell,
    idx::Int64, 
    arr::PointArr, 
    s::Float64
)
    nothing # mem count
    s2 = s^2
    for p1 in cell[key]
        for p2 in cell[nei_cell[idx]]
            if distance(arr, p1, p2) <= s2
                add_pair!(poi_pair, p1, p2)
            end
        end
    end
    poi_pair
end

function add_pair!(poi_pair::PointVec, i::Int64, j::Int64)
    nothing # mem count
    pair1 = (i, j)
    pair2 = (j, i)
    if pair1 ∉ poi_pair && pair2 ∉ poi_pair
        push!(poi_pair, pair1)
    end
    poi_pair
end

NumNod = 1000
Dim = 2
A = rand(NumNod,Dim)
s = 0.1;
a = frnn_main(A,s)

# NumNod = 1000
# julia> @btime FRNNMain($NumNod, $Dim, $A, $s);
#   160.698 ms (78214 allocations: 7.22 MiB)
# julia> @btime frnn_main($A,$s);
#   163.079 ms (7691 allocations: 761.52 KiB)
# julia> @btime frnn_main($A,$s);
#   161.092 ms (90370 allocations: 3.01 MiB)