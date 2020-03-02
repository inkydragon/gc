# Step 0: REPL skeleton

include("Mal_REPL.jl")
using .Mal_REPL

function READ(str)
    str
end

function EVAL(ast, env)
    ast
end

function PRINT(exp)
    exp
end

function rep(str)
    str |> READ |> s->EVAL(s,"") |> PRINT
end

function main_loop()
    PROMPT = "user> "

    print(PROMPT)
    for line in eachline(stdin)
        ('\x04' in line) && break # ^D

        line |> rep |> println
        print(PROMPT)
    end # while true loop end
end

if Mal_REPL.IN_JULIA_REPL
    Mal_REPL.start_repl(rep)
else
    main_loop()
end