# Step 1: REPL skeleton
include("Mal_REPL.jl")
include("types.jl")
include("printer.jl")
include("reader.jl")
using .Mal_REPL

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
    try
        str |> READ |> s->EVAL(s,"") |> PRINT
    catch err
        for (exc, bt) in Base.catch_stack()
            showerror(stdout, exc, bt)
            println()
        end
        "[error] $err"
    end
end

# function main_loop()
#     PROMPT = "user> "

#     print(PROMPT)
#     for line in eachline(stdin)
#         ('\x04' in line) && break # ^D

#         line |> rep |> println
#         print(PROMPT)
#     end # while true loop end
# end

start_repl(rep)
