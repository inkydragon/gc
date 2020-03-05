# dijkstra.jl
include("graph0.jl")
include("load_weight0.jl")

#--------------------------------#
#            Dijkstra            #
#--------------------------------#
function dijkstra(graph::Graph{T},start::UInt64,last::UInt64) where T
    weight=load_weight(graph)
    for (k,v) in weight
        println(k,'\t',v)
    end
    #need a list for save
    list=Dict{UInt64,Int}()
    #init list
    for adjlist in graph.list
        vertex=vertexof(adjlist)
        list[indexof(vertex)] = abs(typemax(Int))
    end
    
    for (vertex,) in edgeof(graph,start)
        list[indexof(vertex)] = weight[start][indexof(vertex)]
        vertex.color = Grey
        vertexof(graph,start).color = Black
    end

    for (minindex,) in list
        if vertexof(graph,minindex).color == Grey
            for (vertex,) in edgeof(graph,minindex)
                if vertex.color != Black
                    list[indexof(vertex)]=min(list[indexof(vertex)],list[minindex]+weight[minindex][indexof(vertex)])
                    vertex.color = Grey
                end
            end
            vertexof(graph,minindex).color = Black
        end
    end

    return list[last]
end

index=Vector{UInt64}(undef,7)

graph=Graph{Int}()
for i in 1:7
    index[i]=append_vertex!(graph,i)
end

append_edge!(graph,index[1],index[2],2)
append_edge!(graph,index[1],index[3],5)
append_edge!(graph,index[2],index[4],1)
append_edge!(graph,index[2],index[5],3)
append_edge!(graph,index[3],index[2],6)
append_edge!(graph,index[3],index[6],8)
append_edge!(graph,index[4],index[5],4)
append_edge!(graph,index[5],index[7],9)
append_edge!(graph,index[6],index[7],7)

res=dijkstra(graph,index[1],index[7])
print(res)