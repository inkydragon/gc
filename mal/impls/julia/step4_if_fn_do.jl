module Mal
# Step 4: If Fn Do
import Base
include("repl.jl")
include("types.jl")
include("reader.jl")
include("printer.jl")
include("env.jl")
include("core.jl")
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
        # (def! <2-sym> <3-val>)
        @assert 3 == length(ast)
        env[ast[2]] = EVAL(ast[3], env)
    elseif MalSym("let*") == f
        # (let* <2-bindings> <3-mal>)
        @assert 3 == length(ast)
        let_env = MalEnv(env)
        bind_env!(let_env, ast[2])
        EVAL(ast[3], let_env)
    elseif MalSym("do") == f
        # (do <2+args...>) => (args[end])
        @assert length(ast) >= 2
        @dbg println("[do] args: $(ast[2:end])")
        # res = MalNil()
        # for exp in ast[2:end]
        #     res = EVAL(exp, env)
        # end
        # @dbg println("[do] res: $res")
        # res
        [ EVAL(exp, env) for exp in ast[2:end] ][end]
    elseif MalSym("if") == f
        # (if <2-case> <3-t-case> [<4-f-case>])
        @assert length(ast) >= 3
        case = EVAL(ast[2], env)
        if  (case isa MalNil) || (case isa MalBool) && !case.val
            # false: nil | false
            res_mal = (3==length(ast)) ? 
                MalNil() :  # (if false <_>)
                ast[4]      # (if false <_> <4-f-case>)
        else
            # true: anything else [0, (), '', ...]
            res_mal = ast[3] # (if false <3-t-case> <_>)
        end
        EVAL(res_mal, env)
    elseif MalSym("fn*") == f
        # (fn* <2-bds> <3-body>)
        @assert 3 == length(ast)
        bds, fn_body = ast[2], ast[3]

        bd_len = length(bds)
        # if 2==bd_len && MalSym("&")==bds[1]
        #     # variadic function parameters
        #     # (fn* (& <2.2-bd>) <3-body>)
        #     @assert 2==length(bds)
        #     bd = bds[2]
        #     _one_arg(args) = args |> MalList |> MalVec
        #     f = (args...) -> EVAL(
        #         fn_body, 
        #         MalEnv(MalList(bd), _one_arg(args), env)
        #     )
        # else
        if bd_len >= 1
            f = (args...) -> EVAL(
                fn_body, 
                MalEnv(bds, MalVec(args), env)
            )
            @dbg f = (args...) -> begin
                println("[fn*] bds=$bds; args=$args")
                new_env = MalEnv(bds, MalVec(args), env)
                println("[fn*] new env:")
                for (k,v) in new_env.data
                    println("  $k => $v")
                end
                println("[fn*] start eval")
                EVAL(fn_body, new_env)
            end
        else # no binding args
            f = () -> EVAL(fn_body, MalEnv(env))
        end
        MalFunc(f)
    else # _default_
        # (<1-fn> <2+args...>)
        new_ast = eval_ast(ast, env)
        # 取出函数与参数
        f = new_ast[1]
        args = new_ast[2:end]
        
        apply(f, args) # 函数调用
    end
end

function PRINT(exp)
    pr_str(exp) |> print
end

function rep(str, repl_env=ns)
    str |> READ |> s->EVAL(s,repl_env) |> PRINT
end
rep("(def! not (fn* (a) (if a false true)))")

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
