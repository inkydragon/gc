# load_weight.jl
# include("graph2.jl")

function load_weight(graph::Graph{T}) where T
    dict=Dict{UInt64,Dict{UInt64,Int}}()
    
    for adjlist in graph.list # Set of AdjList |vertex,Set{Tuple}|
        vertex1,edge=vertexof(adjlist),edgeof(adjlist)
        dict[indexof(vertex1)]=Dict{UInt64,Int}()
        for (vertex2,weight) in edge
            dict[indexof(vertex1)][indexof(vertex2)] = weight
        end
    end

    return dict
end

weight(dict::Dict{UInt64,Dict{UInt64,Int}},index1::UInt64,index2::UInt64) =
    dict[index1][index2]
