module Mal
# Step 3: Environments
import Base
include("repl.jl")
include("types.jl")
include("reader.jl")
include("printer.jl")
include("env.jl")
using .MalREPL # start_repl

export start_repl

const dbg_stack = [true]

function READ(str)
    read_str(str)
end

eval_ast(ast::MalType, _::MalEnv) = ast # _default_
eval_ast(ast::MalSym, env::MalEnv) = env[ast]
eval_ast(ast::T, env::MalEnv) where T <: MalListLike =
    T(MalType[EVAL(m, env) for m in ast])
eval_ast(ast::MalHash, env::MalEnv) =
    [k=>EVAL(v, env) for (k,v) in ast] |>
        MAL_HASH_DICT_TYPE |> 
        MalHash

function apply(f::MalFunc, args)
    f.val(args...)
end

function bind_env!(env::MalEnv, bds::MalListLike)
    len = length(bds)
    isodd(len) && throw("[eval] bindings should be pair. $bds")

    for idx in [[i,i+1] for i in 1:2:len]
        sym, val = bds[idx]
        env[sym] = EVAL(val, env)
    end
end

EVAL(ast::MalType, env::MalEnv) = eval_ast(ast, env)
function EVAL(ast::MalList, env::MalEnv)
    isempty(ast) && return ast

    f = ast[1]
    if MalSym("def!") == f
        env[ast[2]] = EVAL(ast[3], env)
    elseif MalSym("let*") == f
        let_env = MalEnv(env)
        bind_env!(let_env, ast[2])
        EVAL(ast[3], let_env)
    else # _default_
        new_ast = eval_ast(ast, env)
        # 取出函数与参数
        f = new_ast[1]
        args = new_ast[2:end]
        
        apply(f, args) # 函数调用
    end
end

function PRINT(exp)
    pr_str(exp)
end

repl_env = MalEnv(
    :+ => +,
    :- => -,
    :* => *,
    :/ => div,
)
function rep(str)
    str |> READ |> s->EVAL(s,repl_env) |> PRINT |> print
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

MalREPL.start_repl() = start_repl(main_loop)

end # module Mal

using .Mal
start_repl()
