raw"""https://github.com/JuliaLang/julia/issues/53761

Unreachable reached at 000000005717deef
Exception: EXCEPTION_ILLEGAL_INSTRUCTION at 0x5717deef -- dispatch_optimize_constants at C:\Users\cyhan\.julia\packages\SymbolicRegression\0Tn2D\src\ConstantOptimization.jl:33 [inlined]
"""
using SymbolicRegression
using Test
using Random


X = 2 .* randn(MersenneTwister(0), Float32, 2, 1000);
y = 3 * cos.(X[2, :]) + X[1, :] .^ 2 .- 2;

options = SymbolicRegression.Options(;
    binary_operators=(+, *, /, -),
    unary_operators=(cos,),
    crossover_probability=0.0,  # required for recording, as not set up to track crossovers.
    max_evals=10000,
    deterministic=true,
    seed=0,
    verbosity=0,
    progress=false,
);

all_outputs = []
for i in 1:2
    hall_of_fame = @inferred equation_search(
        X,
        y;
        niterations=5,
        options=options,
        parallelism=:serial,
        v_dim_out=Val(1),
        return_state=Val(false),
    )
    dominating = calculate_pareto_frontier(hall_of_fame)
    push!(all_outputs, dominating[end].tree)
end

@test string(all_outputs[1]) == string(all_outputs[2])
