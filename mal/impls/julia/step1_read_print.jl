# Step 1: REPL skeleton
import Base
include("repl.jl")
include("types.jl")
include("reader.jl")
include("printer.jl")
using .MalREPL # start_repl

function READ(str)
    read_str(str)
end

function EVAL(ast, env)
    ast
end

function PRINT(exp)
    pr_str(exp)
end

function rep(str)
    str |> READ |> s->EVAL(s,"") |> PRINT
end

function main_loop(str)
    try
        rep(str)
    catch err
        @dbg for (exc, bt) in Base.catch_stack()
            showerror(stdout, exc, bt)
            println()
        end
        "[error] $err"
    end
end

start_repl(main_loop)
