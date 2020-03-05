# graph.jl
include("list0.jl")

import .LinkedList: Queue
import .LinkedList: push
import .LinkedList: remove
import .LinkedList: @lengthof
#--------------------------------#
#            vertex              #
#--------------------------------#

@enum Color White=0 Grey=1 Black=2

mutable struct Vertex{T}
    value::T
    color::Color
    index::UInt64
    hop::Int
end

Vertex{T}(value::T) where T = Vertex{T}(value,White,0,0)

#----------------#
#       ==       #
#----------------#
Base.:(==)(vertex1::Vertex{T},vertex2::Vertex{T}) where T = vertex1.value == vertex2.value

#----------------#
#     valueof    #
#----------------#
valueof(vertex::Vertex{T}) where T = vertex.value

#----------------#
#     indexof    #
#----------------#
indexof(vertex::Vertex{T}) where T = vertex.index
setindex(vertex::Vertex{T},index::UInt64) where T = vertex.index=index
isvisted(vertex::Vertex{T}) where T = !(notvisited(vertex))
visited!(vertex::Vertex{T}) where T = vertex.color=Black
notvisited(vertex::Vertex{T}) where T = vertex.color == White
# export Vertex
# export Color
# export White
# export Black
# export Grey
# export ==
# export valueof
# export indexof
# export setindex
# end

#--------------------------------#
#            adjlist             #
#--------------------------------#
#module adjlist
#import ..vertex:Vertex

mutable struct AdjList{T}
    vertex::Vertex{T}
    edge::Set{Tuple{Vertex{T},Int}} #contain vertex and weight
end

AdjList{T}(value::T) where T = AdjList{T}(Vertex{T}(value),Set{Tuple{Vertex{T},Int}}())

#Base.iterate(adjlist::AdjList{T}) where T = (adjlist.vertex,adjlist.edge)
#----------------#
#   vertex-of    #
#----------------#
vertexof(adjlist::AdjList{T}) where T = adjlist.vertex

#----------------#
#    edge-of     #
#----------------#

# export AdjList
# export vertexof
#export iterate
#end

#--------------------------------#
#             graph              #
#--------------------------------#
#module graph

# import ..vertex:Vertex
# import ..vertex:indexof
# import ..adjlist:vertexof
# import ..adjlist:AdjList

mutable struct Graph{T}
    vcount::Int
    ecount::Int
    list::Set{AdjList{T}}
    hasdirection::Bool
end

Graph{T}(direct=true) where T = Graph{T}(0,0,Set{AdjList{T}}(),direct)
#----------------#
#    vertexof    #
#----------------#
vertexof(graph::Graph{T},index::UInt64) where T =
    begin
        for current in graph.list
            if indexof(current.vertex) == index
                return current.vertex
            end
        end
    end
#----------------#
#   getadjlist   #
#----------------#
getadjlist(graph::Graph{T},index::UInt64) where T = begin
    for current in graph.list #AdjList
        if indexof(vertexof(current)) == index
            return current
        end
    end
end


# export Graph
# export getadjlist

# end



#--------------------------------#
#           function             #
#--------------------------------#
# using .vertex
# using .adjlist
# using .graph


#----------------#
#     edgeof     #
#----------------#
edgeof(graph::Graph{T},index::UInt64) where T = begin
    adjlist=getadjlist(graph,index)
    if adjlist != nothing
        adjlist.edge
    end
end

edgeof(adjlist::AdjList{T}) where T = adjlist.edge
#--------------------------------#
#            append              #
#--------------------------------#

#------------------------#
#   add vertex -> index  #
#------------------------#
function append_vertex!(graph::Graph{T},value::T) where T# return index
    for adjlist in graph.list #AdjList
        if value == valueof(vertexof(adjlist))
            return
        end
    end

    new_elmt = AdjList{T}(value)
    index=hash(value)
    graph.vcount+=1
    setindex(vertexof(new_elmt),index)
    push!(graph.list,new_elmt)
    index

end

#------------------------#
#add egde with two index #
#------------------------#
function append_edge!(graph::Graph{T},index1::UInt64,index2::UInt64,w::Int=0) where T# w: 权重
    #judge that if index1 and index2 is in each vertex of graph.list(AdjList)
    adjlist1=getadjlist(graph,index1)
    adjlist2=getadjlist(graph,index2)
    if adjlist1 == nothing || adjlist2 == nothing
        return
    end

    if graph.hasdirection == true
        push!(edgeof(adjlist1),(vertexof(adjlist2),w))
    else
        push!(edgeof(adjlist1),(vertexof(adjlist2),w))
        push!(edgeof(adjlist2),(vertexof(adjlist1),w))
    end
    
    graph.ecount+=1
end