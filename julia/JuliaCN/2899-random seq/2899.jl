using Test
using Random

# 求给定数组中最大连续子序列的长度
function max_seq_len(v::Vector{Int})
    pk = 1 
    nk = 1 
    ptemp = 0 # 递增连续子序列的长度
    ntemp = 0 # 递减连续子序列的长度
    for i in 2:length(v) 
        if v[i] - v[i - 1] == 1
            pk += 1
        elseif v[i] - v[i - 1] == -1 
            nk += 1
        else
            pk = 1
            nk = 1
        end
        if pk > ptemp
            ptemp = pk
        end
        if nk > ntemp
            ntemp = nk
        end
    end
    return max(ptemp, ntemp)
end
max_seq_len(r::UnitRange) = max_seq_len(collect(r))
@test max_seq_len(1:10) == 10
@test max_seq_len(1:500) == 500
@test max_seq_len(vcat([500], 1:100)) == 100
@test max_seq_len(vcat([500, 0], 1:100, 6)) == 101
@test max_seq_len(vcat([500, 0], 100:-1:1)) == 100
@test max_seq_len(vcat([500, 0], 100:-1:1, 0)) == 101

function gt14(r::Int)
    # 数组result中的最大连续子序列长度是否大于14
    # Int(maxlian(result) >= 14) 
    r>=14 ? 1 : 0
end

function main(test_num=1)
    k = 0
    for i = 1:test_num
        # 从1:1138中不重复随机采样514个数作为数组
        # 考察其最大连续子序列长度
        k += (randperm(1138)[1:514] 
            |> max_seq_len
            |> gt14)
    end
    k
end 

num = 100000000 # 实验次数
# k = main(1000)
# println("14连号出现频率为：", k/num)
