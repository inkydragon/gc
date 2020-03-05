# graph.jl
# include("list.jl")
# import .LinkedList: Queue, push, remove, @lengthof
# 并没有用到以上函数

#--------------------------------#
#            vertex              #
#--------------------------------#

"""
    @enum Color begin
        White = 0
        Grey
        Black
    end

代顶点边是否访问过
+ `White` 未访问
+ `Grey`
+ `Black` 已访问
"""
@enum Color begin
    White = 0
    Grey
    Black
end
# @enum Color White=0 Grey=1 Black=2

"""
    mutable struct Vertex{T}
        name  :: T
        color :: Color
    end
    Vertex(name::T)

顶点 Vertex{T}
+ `name::T` 顶点代号，建议使用 :keyword、"String"、或 Integer
+ `color::Color` 顶点访问状态
"""
mutable struct Vertex{T}
    # value::T
    name::T
    color::Color
    # index::UInt64 # 直接使用 name
    # hop::Int # 貌似没用上

    function Vertex{T}(name::T) where T
        # new(name, White, 0, 0)
        new(name, White)
    end
end
Vertex(name::T) where T = Vertex{T}(name) # 自动推断类型参数 T
Base.show(io::IO, v::Vertex) = # 美化输出
    print(io, "[$(repr(v.name))] $(v.color)")

"名字作为唯一标识符"
Base.:(==)(vertex1::Vertex{T}, vertex2::Vertex{T}) where T =
    vertex1.name == vertex2.name

# valueof(vertex::Vertex{T}) where T = vertex.value
nameof(vertex::Vertex) = vertex.name

# indexof(vertex::Vertex) = vertex.index
# setindex(vertex::Vertex, index::UInt64) = vertex.index=index
visited!(vertex::Vertex) = vertex.color = Black
isvisted(vertex::Vertex) = !(notvisited(vertex))
notvisited(vertex::Vertex) = vertex.color == White



#--------------------------------#
#            adjlist             #
#--------------------------------#

"边的类型。edge: (end_point, weight)"
const Edge{T} = Tuple{Vertex{T}, Int}

"""
    mutable struct AdjList{T}
        vertex :: Vertex{T}
        edges  :: Vector{Edge{T}}
    end
    Edge{T} = Tuple{Vertex{T}, Int}
    AdjList(name::T)

邻接表节点 AdjList{T}
"""
mutable struct AdjList{T}
    vertex::Vertex{T}
    # edge::Set{Tuple{Vertex{T},Int}}
    edges::Vector{Edge{T}}

    function AdjList{T}(name::T) where T
        new(Vertex(name), Vector{Edge{T}}())
    end
end
# AdjList{T}(value::T) where T = AdjList{T}(Vertex{T}(value),Set{Tuple{Vertex{T},Int}}())
AdjList(name::T) where T = AdjList{T}(name)
function Base.show(io::IO, adjlist::AdjList)
    v0 = adjlist.vertex
    if isempty(adjlist.edges)
        println(io, "$v0 [no edge]")
    else
        for (v, w) in adjlist.edges
            println(io, "$v0 =($w)=> $v")
        end
    end
end

# Base.iterate(adjlist::AdjList{T}) where T = (adjlist.vertex,adjlist.edges)
vertexof(adjlist::AdjList) = adjlist.vertex
edgesof(adjlist::AdjList)  = adjlist.edges



#--------------------------------#
#             graph              #
#--------------------------------#
"""
    mutable struct Graph{T}
        vcount :: Int
        ecount :: Int
        list   :: Vector{AdjList{T}}
        hasdirection :: Bool
    end
    Graph{T}(has_direction=true)

图 Graph{T}
+ `vcount` 顶点数
+ `ecount` 边数
+ `list`   邻接表
+ `hasdirection` 是否有向
"""
mutable struct Graph{T}
    vcount::Int
    ecount::Int
    # list::Set{AdjList{T}}
    list::Vector{AdjList{T}}
    hasdirection::Bool

    function Graph{T}(direct::Bool=true) where T
        new(0, 0, Vector{AdjList{T}}(), direct)
    end
end
# Graph{T}(direct=true) where T = Graph{T}(0,0,Set{AdjList{T}}(),direct)
function Base.show(io::IO, g::Graph{T}) where T
    print(io, (g.hasdirection ? "Directed " : "") * "Graph{$T} ")
    print(io, "vertexs = $(g.vcount); edges = $(g.ecount)\n")
    if isempty(g.list)
        println(io, "[empty]")
    else
        for adj in g.list
            print(io, adj)
        end
    end
end

"返回 name 对应的顶点开头的邻接表 AdjList"
function Base.getindex(graph::Graph{T}, names::T) where T
    # 便于使用
    for current in graph.list # current::AdjList
        if names == nameof(vertexof(current))
            return current
        end
    end
    nothing
end

# vertexof(graph::Graph{T},index::UInt64) where T =
#     begin
#         for current in graph.list
#             if indexof(current.vertex) == index
#                 return current.vertex
#             end
#         end
#     end
"返回 name 对应的顶点"
vertexof(graph::Graph{T}, name::T) where T =
    vertexof(graph[name])

# getadjlist(graph::Graph{T},index::UInt64) where T = begin
#     for current in graph.list #AdjList
#         if indexof(vertexof(current)) == index
#             return current
#         end
#     end
# end
"返回 name 对应的顶点开头的邻接表 AdjList"
getadjlist(graph::Graph{T}, name::T) where T = graph[name]



#--------------------------------#
#           function             #
#--------------------------------#

# function edgesof(graph::Graph, index::UInt64)
#     adjlist = getadjlist(graph, index)
#     if adjlist != nothing
#         adjlist.edges
#     end
# end
"返回 name 对应顶点开头的边"
edgesof(graph::Graph{T}, name::T) where T = edgesof(graph[name])

# edgeof(adjlist::AdjList{T}) where T = adjlist.edge
# 前移至 AdjList 定义处

"辅助函数"
Base.in(name::T, graph::Graph{T}) where T =
    getadjlist(graph, name) != nothing

"""
    append_vertex!(graph::Graph{T}, name::T) where T
"""
# function append_vertex!(graph::Graph{T},value::T) where T
function append_vertex!(graph::Graph{T}, names::T...) where T
    # for adjlist in graph.list #AdjList
    #     if value == valueof(vertexof(adjlist))
    #         return
    #     end
    # end
    for name in names
        (name in graph) && return

        new_elmt = AdjList(name)
        # index = hash(name)
        # setindex(vertexof(new_elmt),index)
        push!(graph.list, new_elmt)
        graph.vcount += 1
        # index
    end
end
function Graph(direct::Bool, names::T...) where T
    graph = Graph{T}(direct)
    append_vertex!(graph, names...)
    graph
end
Graph(direct::Bool, r::UnitRange{T}) where T<:Integer =
    Graph(direct::Bool, collect(r)...)

#-------------------------#
# add egde with two index #
#-------------------------#

"""
    append_edge!(
        graph::Graph{T},
        index1::UInt64,
        index2::UInt64,
        w::Int=0
    ) where T

w: 权重
"""
# function append_edge!(graph::Graph{T},index1::UInt64,index2::UInt64,w::Int=0) where T
function append_edge!(
        graph::Graph{T},
        name1::T,
        name2::T,
        w::Int=0
    ) where T
    # judge that if index1 and index2 is in each vertex of graph.list(AdjList)
    adjlist1 = getadjlist(graph, name1)
    adjlist2 = getadjlist(graph, name2)
    # if adjlist1 == nothing || adjlist2 == nothing
    #     return
    # end
    name1 ∉ graph || name2 ∉ graph && return
    

    if graph.hasdirection
        push!(edgesof(adjlist1), (vertexof(adjlist2),w))
    else
        push!(edgesof(adjlist1), (vertexof(adjlist2),w))
        push!(edgesof(adjlist2), (vertexof(adjlist1),w))
    end

    graph.ecount += 1
end

"graph[:a, :b] = weight"
Base.setindex!(graph::Graph{T}, w::Int, name1::T, name2::T) where T =
    append_edge!(graph, name1, name2, w)
