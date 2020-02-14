# KNN (k-nearest neighbor)

# L_2 欧氏距离
function distance(
          x::Array{T, 1}
        , y::Array{T, 1}
    ) where T <: Number
    
    dist = 0
    for i in 1:length(x)
        dist += (x[i]-y[i])^2
    end
    dist = sqrt(dist)
    return dist
end


function classify(  
          distances::Array{Float64, 1}
        , labels::Array{T, 1}
        , k::Int64
    ) where T <: Any

    class = unique(labels)
    nc    = length(class)
    class_count = Array(Int, nc)
    
    indexes     = Array(Int, 0)
    M           = typemax(typeof(distances[1]))
    
    
    for i in 1:k
        indexes[i] = typemin(distances) # Inf
        distances[indexes[i]] = M # 不会数组越界？
    end

    klabels = labels[indexes]
    for i in 1:nc
        for j in 1:k
            if klabels[j] == class[i]
                class_count[i] += 1
                break
            end
        end
    end

    index = max(class_count)
    return class[index]
end


function apply_KNN(
          X::Array{T1, 2}
        , x::Array{T2, 1}
        , Y::Array{T1, 2}
        , k::Int64
    ) where {T1 <: Number, T2 <: Any}

    N = size(X, 1)
    n = size(Y, 1)
    D = Array(Float64, N)
    Z = Array(typeof(x[1]), n)

    for i in 1:n
        for j in 1:N
            D[j] = distance(X[j,:], Y[i,:])
        end
        z[i] = classify(D, x, k)
    end

    return z
end



# Test
data = readdlm("tst.csv", ',')

I = map(Float64, data[:, 1:(end-1)])
O = data[:, end]
N = length(O)
n = round(Int64, N/2)
R = randperm(N)

indX = R[1:n]
X = I[indX, :]
x = O[indX]

indY = R[(n+1): end]
Y = I[indY, :]
y = O[indY]

z = apply_KNN(X, x, Y, 5)

println(sum(y .== z[1])/n)
Println(z[1][1:5], z[2][1:5])
