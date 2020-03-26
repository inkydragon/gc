
function forloop(A::Matrix{Float64},NumNod::Int64,s::Float64)
    PoiPair = []
    for i = 1:NumNod-1
        for j = i+1:NumNod
            Point1 = A[i,:]
            Point2 = A[j,:]
            Dist = (Point1[1]-Point2[1])^2+(Point1[2]-Point2[2])^2
            if Dist < s
                push!(PoiPair,(i,j))
            end
        end
    end
    return PoiPair
end

# NumNod = 1000
# Dim = 2
# A = rand(NumNod,Dim)
# s = 0.1;
# b = forloop(A,NumNod,s)