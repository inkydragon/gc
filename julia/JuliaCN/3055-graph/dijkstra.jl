# dijkstra.jl
include("graph.jl")
include("load_weight.jl")

#--------------------------------#
#            Dijkstra            #
#--------------------------------#
# function dijkstra(graph::Graph{T},start::UInt64,last::UInt64) where T
function dijkstra(
        graph::Graph{T}, 
        start::T, 
        last::T
    ) where T
    weight = load_weight(graph)
    println("Weights:")
    for (k,v) in weight
        # println(k,'\t',v)
        println("  $k => $v")
    end

    # need a list for save
    # list=Dict{UInt64,Int}()
    distance = Dict{T, Int}()   # 记录各点到起点的最短距离
    # init distance
    for adjlist in graph.list
        vtx_name = adjlist |> vertexof |> nameof
        distance[vtx_name] = abs(typemax(Int)) # 初始化距离为 max
    end

    # 为起点 start 相连的点赋值 distance
    for (vertex, _) in edgesof(graph, start)
        vtx_name = nameof(vertex)
        distance[vtx_name] = weight[start, vtx_name]
        vertex.color = Grey # 访问过，但不确定是否最小
    end
    # 起点自身赋值
    vertexof(graph,start).color = Black

    # 从 Grey 开始
    for (minindex, _) in distance
        # if vertexof(graph, minindex).color == Grey
        Grey!=vertexof(graph, minindex).color && continue

        for (vertex, _) in edgesof(graph,minindex)
            # if vertex.color != Black
            Black==vertex.color && continue
            
            vtx_name = nameof(vertex)
            distance[vtx_name] = min(
                distance[vtx_name],
                distance[minindex] + weight[minindex, vtx_name]
            )
            vertex.color = Grey
            # end
        end
        vertexof(graph, minindex).color = Black
        # end
    end

    return distance[last]
end

# index = Vector{UInt64}(undef, 7)
# graph = Graph{Int}()
# for i in 1:7
#     index[i] = append_vertex!(graph,i)
# end
graph = Graph(true, 1:7)

# append_edge!(graph,index[1],index[2],2)
# append_edge!(graph,index[1],index[3],5)
# append_edge!(graph,index[2],index[4],1)
# append_edge!(graph,index[2],index[5],3)
# append_edge!(graph,index[3],index[2],6)
# append_edge!(graph,index[3],index[6],8)
# append_edge!(graph,index[4],index[5],4)
# append_edge!(graph,index[5],index[7],9)
# append_edge!(graph,index[6],index[7],7)
graph[1, 2] = 2
graph[1, 3] = 5
graph[2, 4] = 1
graph[2, 5] = 3
graph[3, 2] = 6
graph[3, 6] = 8
graph[4, 5] = 4
graph[5, 7] = 9
graph[6, 7] = 7

# graph[1, 2] = 2
# graph[1, 4] = 1
# graph[2, 4] = 3
# graph[2, 5] = 10
# graph[3, 1] = 4
# graph[3, 6] = 5
# graph[4, 3] = 2
# graph[4, 5] = 2
# graph[4, 6] = 8
# graph[4, 7] = 4
# graph[5, 7] = 6
# graph[7, 6] = 1
# res == 5

# res=dijkstra(graph,index[1],index[7])
# print(res)
res = dijkstra(graph, 1, 7)
println("shortest length: $res")
