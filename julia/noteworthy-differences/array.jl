## 数组的构造
[1, 2, 3]
# 3-element Array{Int64,1}:
#  1
#  2
#  3
[1 2 3]
# 1×3 Array{Int64,2}:
#  1  2  3

[1, [0 0], 3]
# 3-element Array{Any,1}:
#  1
#   [0 0]
#  3
[1 [0 0] 3]
# 1×4 Array{Int64,2}:
#  1  0  0  3

[1, 2, 3] == [1 2 3]
# false
[1, 2, 3] == [1; 2; 3]
# true

[1; 2; 3]
# 3-element Array{Int64,1}:
#  1
#  2
#  3

[1 2; 3 4]
# 2×2 Array{Int64,2}:
#  1  2
#  3  4

rand(3)
# 3-element Array{Float64,1}:
#  0.4672600683116248
#  0.09169094140222867
#  0.4042011717217615

rand(3, 1)
# 3×1 Array{Float64,2}:
#  0.06339164760309646
#  0.9777149900468021
#  0.6649767538620179

rand(3, 3)
# 3×3 Array{Float64,2}:
#  0.587354  0.422352  0.439107
#  0.528044  0.872661  0.374443
#  0.207286  0.356782  0.861222


## 数组的拼接
a = [1 2];

hcat(a, a, a)
# 1×6 Array{Int64,2}:
#  1  2  1  2  1  2

[a a a]
# 1×6 Array{Int64,2}:
#  1  2  1  2  1  2

hcat(a, a, a) == [a a a]
# true

vcat(a, a, a)
# 3×2 Array{Int64,2}:
#  1  2
#  1  2
#  1  2

[a; a; a]
# 3×2 Array{Int64,2}:
#  1  2
#  1  2
#  1  2

vcat(a, a, a) == [a; a; a]
# true

# a = [1 2];
b = [3 4];
[a b; a b]
# 2×4 Array{Int64,2}:
#  1  2  3  4
#  1  2  3  4

hvcat((4,4), a..., b..., a..., b...)
# 2×4 Array{Int64,2}:
#  1  2  3  4
#  1  2  3  4

[a a; b b]
# 2×4 Array{Int64,2}:
#  1  2  1  2
#  3  4  3  4

hvcat((4,4), a..., a..., b..., b...)
# 2×4 Array{Int64,2}:
#  1  2  1  2
#  3  4  3  4


## 数组的索引
a = [1 2 3; 4 5 6]
# 2×3 Array{Int64,2}:
#  1  2  3
#  4  5  6
a[1, 1]
# 1

hcat(a...)
# 1×6 Array{Int64,2}:
#  1  4  2  5  3  6


collect(1:5)
# 5-element Array{Int64,1}:
#  1
#  2
#  3
#  4
#  5

1:2:10
# 1:2:9

collect(1:2:10)
# 5-element Array{Int64,1}:
#  1
#  3
#  5
#  7
#  9


## sum, prod, max
a = [1 2 3; 4 5 6]
# 2×3 Array{Int64,2}:
#  1  2  3
#  4  5  6

sum(a)
# 21
sum(a; dims=1)
# 1×3 Array{Int64,2}:
#  5  7  9

prod(a)
# 720
prod(a; dims=1)
# 1×3 Array{Int64,2}:
#  4  10  18

max(a...)
# 6
maximum(a; dims=1)
# 1×3 Array{Int64,2}:
#  4  5  6


## 布尔运算
a = [1 2 3];
b = [4 5 6];

a == b
# false

a .== b
# 1×3 BitArray{2}:
#  0  0  0
all(a .== b)
# false


a = [true true false false]
# 1×4 Array{Bool,2}:
#  1  1  0  0
b = [true false true false]
# 1×4 Array{Bool,2}:
#  1  0  1  0

a .& b
# 1×4 BitArray{2}:
#  1  0  0  0
a .| b
# 1×4 BitArray{2}:
#  1  1  1  0
a .⊻ a  # xor.(a, a)
# 1×4 BitArray{2}:
#  0  0  0  0


A = [1 2 3 4];
(A .== 1) .| (A .== 2)
# 1×4 BitArray{2}:
#  1  1  0  0

A[(A .== 1) .| (A .== 2)]
# 2-element Array{Int64,1}:
#  1
#  2
filter(y -> y==1 || y==2, A)
# 2-element Array{Int64,1}:
#  1
#  2


A = [1, 2, 3, 4]
# 4-element Array{Int64,1}:
#  1
#  2
#  3
#  4

filter(y -> y > 3, A)
# 1-element Array{Int64,1}:
#  4
A
# 4-element Array{Int64,1}:
#  1
#  2
#  3
#  4

filter!(y -> y > 3, A)
# 1-element Array{Int64,1}:
#  4
A
# 1-element Array{Int64,1}:
#  4


## 赋值
a = [1 2 3]
# 1×3 Array{Int64,2}:
#  1  2  3
b = a
# 1×3 Array{Int64,2}:
#  1  2  3

b[2] = 0
# 0
a
# 1×3 Array{Int64,2}:
#  1  0  3

c = copy(a)
# 1×3 Array{Int64,2}:
#  1  0  3
c[2] = -1
# -1
c
# 1×3 Array{Int64,2}:
#  1  -1  3
a
# 1×3 Array{Int64,2}:
#  1  0  3


a = [];
a[4]
# ERROR: BoundsError: attempt to access 0-element Array{Any,1} at index [4]
# Stacktrace...
append!(a, [0 0 0])
# 3-element Array{Any,1}:
#  0
#  0
#  0

push!(a, 3.2)
# 4-element Array{Any,1}:
#  0
#  0
#  0
#  3.2

push!(a, 7)
# 5-element Array{Any,1}:
#  0
#  0
#  0
#  3.2
#  7

push!(a, 10)
# 6-element Array{Any,1}:
#   0
#   0
#   0
#   3.2
#   7
#  10

a
# 6-element Array{Any,1}:
#   0
#   0
#   0
#   3.2
#   7
#  10



## 杂项
sqrt(-1)
# ERROR: DomainError with -1.0:
# sqrt will only return a complex result if called with a complex argument. Try sqrt(Complex(x)).
# Stacktrace...
sqrt(Complex(-1))
# 0.0 + 1.0im
sqrt(-1 + 0im)
# 0.0 + 1.0im
im
# im
1im
# 0 + 1im

im * im
# -1 + 0im
im * im == Complex(-1)
# true


42
# 42
typeof(42)
# Int64

42.0
# 42.0
typeof(42.0)
# Float64

big"42"
# 42
typeof(big"42")
# BigInt