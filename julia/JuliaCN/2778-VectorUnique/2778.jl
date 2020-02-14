# ref: - [解锁多种JavaScript数组去重姿势 - 掘金](https://juejin.im/post/5b0284ac51882542ad774c45)

# 双层循环
function unique_for2_1(vv::Vector)
    new_arr = similar(vv, 0)
    for i in vv
        is_repeat = false
        for j in new_arr
            if i==j
                is_repeat = true
                break
            end
        end
        if !is_repeat
            push!(new_arr, i)
        end
    end
    new_arr
end

function unique_for2_2(vv::Vector)
    new_arr = similar(vv, 0)
    len = length(vv)
    for i in 1:len
        is_repeat = false
        for j in (i+1):len
            if vv[i]==vv[j]
                is_repeat = true
                break
            end
        end
        if !is_repeat
            push!(new_arr, vv[i])
        end
    end
    new_arr
end

# 过滤器
# function unique_filter(vv::Vector)
#     new_arr = similar(vv, 0)
#     for (index, value) in enumerate(vv)
#         index==getindex(vv, value) &&
#             push!(new_arr, value)
#     end
#     new_arr
# end

function unique_filter_2(vv::Vector)
    new_arr = similar(vv, 0)
    filter(vv) do v
        flag = !(v in new_arr)
        flag && push!(new_arr, v)
        flag
    end
end

# 先排序
function unique_sort_1(vv::Vector)
    new_arr = similar(vv, 0)
    vv = sort(vv)
    len = length(vv)
    for i in 1:(len-1)
        if vv[i]!=vv[i+1]
            push!(new_arr, vv[i])
        end
    end
    new_arr
end

function unique_sort_2(vv::Vector)
    new_arr = copy(vv[1:1])
    vv = sort(vv)
    len = length(vv)
    for i in 2:len
        if vv[i]!=new_arr[end]
            push!(new_arr, vv[i])
        end
    end
    new_arr
end

