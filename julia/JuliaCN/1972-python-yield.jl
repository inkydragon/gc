# def all_order(n: int, c: List[int]):
#     if len(c) == n:
#         yield c
#     elif len(c) < n:
#         for i in range(n):
#             v = i + 1
#             if v in c:
#                 continue
#             c.append(v)
#             for result in all_order(n, c):
#                 yield result
#             c.pop()
# 
# 
# for r in all_order(3, []):
#     print(r)

function all_order(n::Int, l::Vector=[])
    Channel(c->producer(c, n, l))
end

function producer(c::Channel, n, l)
    if length(l) == n
        put!(c, l)
    elseif length(l) < n
        for i in 1:n
            if i in l
                continue
            end
            for r in all_order(n, vcat(l, i))
                put!(c, r)
            end
        end
    end
end;

for r in all_order(3)
    println(r)
end
