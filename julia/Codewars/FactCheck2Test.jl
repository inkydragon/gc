# - [JuliaAttic/FactCheck.jl: Midje-like testing for Julia](https://github.com/JuliaAttic/FactCheck.jl)

#= 
    Basics
=#
# using FactCheck
using Test

# facts("With a description") do
#     # Your tests here
# end
@testset "trigonometric identities" begin
    # Your tests here
end
       
# facts() do
#     # Your tests here
# end
@testset begin
    # Your tests here
end

# facts("Lots of tests") do
#     context("First group") do
#         # ...
#     end
#     context("Second group") do
#         # ...
#     end
# end
@testset "Lots of tests" begin
    @testset "First group" begin
        # ...
    end
    @testset "Second group" begin
        # ...
    end
end

# facts("Testing basics") do
#     @fact 1 --> 1
#     @fact 2*2 --> 4
#     @fact uppercase("foo") --> "FOO"
#     @fact_throws 2^-1
#     @fact_throws DomainError 2^-1
#     @fact_throws DomainError 2^-1 "a nifty message"
#     @fact 2*[1,2,3] --> [2,4,6]
# end
@testset "Testing basics" begin
    @test 1 == 1
    @test 2*2 == 4
    @test uppercase("foo") == "FOO"
    # @test_throws 2^-1   # this will not throw
    @test_throws MethodError 2^-    # MethodError
    # @test_throws MethodError 2^- "a nifty message" # not supported
    @test 2*[1,2,3] == [2,4,6]
end

@testset "Testing basics" begin
    @test 1==1
    @test 2==1 || "2 should equ to 2"
end

