a = [1 2 3]
# 1×3 Array{Int64,2}:
#  1  2  3

println(a)
# [1 2 3]
println(a...)
# 123


function f1()
    print("func 1: ")
    1, 2, 3
end
# f1 (generic function with 1 method)
f1()
# func 1: (1, 2, 3)
ans
# (1, 2, 3)


function subtract(y , x; absdif = false)
    dif = y - x
    if absdif
        println("Calculating absolute value")
        dif, abs(dif)
    else
        dif
    end
end
# subtract (generic function with 1 method)

subtract(5, 10)
# -5
subtract(5, 10; absdif=true)
# Calculating absolute value
# (-5, 5)


using LinearAlgebra
A = [2 0 2; 0 1 0; 0 0 0];
F = svd(A);

F.S
# 3-element Array{Float64,1}:
#  2.8284271247461903
#  1.0
#  0.0
Diagonal(F.S)
# 3×3 Diagonal{Float64,Array{Float64,1}}:
#  2.82843   ⋅    ⋅
#   ⋅       1.0   ⋅
#   ⋅        ⋅   0.0
