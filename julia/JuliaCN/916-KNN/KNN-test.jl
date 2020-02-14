include("KNN.jl")
using Test

@testset "Basic Test Set" begin
    LENGTH = 1000
    ZERO = zeros(Int64, LENGTH)
    x = rand(-100:100, LENGTH)
    y = rand(-100:100, LENGTH)
    
    @test Euclidean(x, ZERO)^2 == sum(abs2.(x))
    @test Euclidean(x, y)^2 == sum(abs2.(x - y))
end

 
 