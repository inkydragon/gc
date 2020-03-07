# Step 2: Eval
include("Mal_REPL.jl")
include("types.jl")
include("printer.jl")
include("reader.jl")
using .Mal_REPL

const dbg_stack = [true]

function READ(str)
    read_str(str)
end

eval_ast(ast::MalType, _) = ast
function eval_ast(ast::MalSym, env)
    res = get(env, ast, nothing)
    isnothing(res) && throw("[eval] symbol '$ast' not found!")
    res
end
eval_ast(ast::T, env) where T <: Union{MalList, MalVec} =
    T(MalType[EVAL(m, env) for m in ast])
eval_ast(ast::MalHash, env) =
    [k=>EVAL(v, env) for (k,v) in ast] |>
        MAL_HASH_DICT_TYPE |> 
        MalHash

function apply(f::MalFunc, args)
    f.val(args...)
end

EVAL(ast::MalType, env) = eval_ast(ast, env)
function EVAL(ast::MalList, env)
    isempty(ast) && return ast

    new_ast = eval_ast(ast, env)
    # 取出函数与参数
    f = new_ast[1]
    args = new_ast[2:end]
    # 函数调用
    apply(f, args)
end

function PRINT(exp)
    pr_str(exp)
end

repl_env = Dict(
    :+ => MalFunc(+),
    :- => MalFunc(-),
    :* => MalFunc(*),
    :/ => MalFunc(div),
)
function rep(str)
    str |> READ |> s->EVAL(s,repl_env) |> PRINT
end

function main_loop(str)
    try
        rep(str)
    catch err
        @dbg dbg_stack[] && for (exc, bt) in Base.catch_stack()
            showerror(stdout, exc, bt)
            println()
        end
        "[error]$err"
    end
end

start_repl(main_loop)
