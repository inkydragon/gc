# load_weight.jl
# include("graph2.jl")

# function load_weight(graph::Graph{T}) where T
function load_weight(graph::Graph{T}) where T
    # dict=Dict{UInt64,Dict{UInt64,Int}}()
    dict = Dict{Tuple{T,T}, Int}()

    for adjlist in graph.list # Set of AdjList |vertex,Set{Tuple}|
        vertex1, edges = vertexof(adjlist), edgesof(adjlist)
        # dict[indexof(vertex1)]=Dict{UInt64,Int}()
        for (vertex2, weight) in edges
            # dict[indexof(vertex1)][indexof(vertex2)] = weight
            name_tup = (nameof(vertex1), nameof(vertex2))
            dict[name_tup] = weight
        end
    end

    dict
end

# weight(dict::Dict{UInt64,Dict{UInt64,Int}},index1::UInt64,index2::UInt64) =
#     dict[index1][index2]

"dict[name1, name2]"
Base.getindex(
    dict::Dict{Tuple{T,T}, Int},
    name1::T, name2::T
) where T = dict[(name1, name2)]
