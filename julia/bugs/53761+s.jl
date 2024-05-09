raw"""https://github.com/JuliaLang/julia/issues/53761

Unreachable reached at 000000005717deef
Exception: EXCEPTION_ILLEGAL_INSTRUCTION at 0x5717deef -- dispatch_optimize_constants at C:\Users\cyhan\.julia\packages\SymbolicRegression\0Tn2D\src\ConstantOptimization.jl:33 [inlined]
"""

using SymbolicRegression


X = zeros(2, 1);
y = zeros(1);

equation_search(X, y)
