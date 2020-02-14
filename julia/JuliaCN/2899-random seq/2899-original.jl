using Distributed

addprocs()


@everywhere using Random

# 求给定数组中最大连续子序列的长度
@everywhere function maxlian(v::Vector{Int})
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
                        if pk > ptemp
                            ptemp = pk
                        end
                        if nk > ntemp
                            ntemp = nk
                        end
                        pk = 1
                        nk = 1
                    end
                end
                return max(ptemp, ntemp)
            end

num = 100000000 # 实验次数

@everywhere function ishave(result)
               Int(maxlian(result) >= 14) # 数组result中的最大连续子序列长度是否大于14
            end

k = @distributed (+) for i = 1:num
                        ishave(randperm(1138)[1:514]) # 从1:1138中不重复随机采样514个数作为数组，考察其最大连续子序列长度
                     end

println("14连号出现频率为：", k/num)