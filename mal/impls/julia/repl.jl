module MalREPL
import REPL      # for script without REPL
import ReplMaker # for Julia's REPL

export start_repl, IN_JULIA_REPL

# 判断是否在 Julia 的 REPL 中
const IN_JULIA_REPL = isdefined(Base, :active_repl)
const NOT_IN_JULIA_REPL = ! IN_JULIA_REPL
const MAL_PROMPT = "user> " # 自定义的 prompt

# 全局变量，用于处理输入
const global BasicREPL_INPUT_LINE_FUNC = Vector{Function}()
push!(BasicREPL_INPUT_LINE_FUNC, identity)


#= COPY FROM `REPL.jl` && `client.jl` ====================================== =#
if NOT_IN_JULIA_REPL

# stdlib/REPL.jl#L215
# 修改：用于支持 BasicREPL 的自定义
#   1. MAL_PROMPT
#   2. BasicREPL_INPUT_LINE_FUNC
function REPL.run_frontend(repl::REPL.BasicREPL, backend::REPL.REPLBackendRef)
    d = REPL.REPLDisplay(repl)
    dopushdisplay = !in(d,Base.Multimedia.displays)
    dopushdisplay && pushdisplay(d)
    hit_eof = false
    while true
        Base.reseteof(repl.terminal)
  #=1=# write(repl.terminal, MAL_PROMPT)
        line = ""
        ast = nothing
        interrupted = false
        while true
            try
                line *= readline(repl.terminal, keep=true)
            catch e
                if isa(e,InterruptException)
                    try # raise the debugger if present
                        ccall(:jl_raise_debugger, Int, ())
                    catch
                    end
                    line = ""
                    interrupted = true
                    break
                elseif isa(e,EOFError)
                    hit_eof = true
                    break
                else
                    rethrow()
                end
            end
            # ast = Base.parse_input_line(line)
  #=2=#     ast = Base.invokelatest(BasicREPL_INPUT_LINE_FUNC[], line)
            (isa(ast,Expr) && ast.head === :incomplete) || break
        end
        if !isempty(line)
            response = REPL.eval_with_backend(ast, backend)
            REPL.print_response(repl, response, !REPL.ends_with_semicolon(line), false)
        end
        write(repl.terminal, '\n')
        ((!interrupted && isempty(line)) || hit_eof) && break
    end
    # terminate backend
    put!(backend.repl_channel, (nothing, -1))
    dopushdisplay && popdisplay(d)
    nothing
end

end # end if NOT_IN_JULIA_REPL
#= COPY END ================================================================ =#


"""
单独定制的 REPL。包含 LineEdit 功能。

可自定义 prompt，输入处理函数，输出格式。
支持从 julia 中启动；或者直接从脚本文件启动。
"""
function start_repl(repl_func::Function)
    if IN_JULIA_REPL
        ReplMaker.initrepl(
            repl_func,
            prompt_text = "user> ",
            # prompt_color = :blue,
            start_key = ')',
            repl = Base.active_repl,
            mode_name = :mal_lisp,
            # valid_input_checker::Function = (s -> true),
            startup_text = false
        )
    else # NOT_IN_JULIA_REPL: ref: https://discourse.juliacn.com/t/topic/3038
    # copy from: base/client.jl#L367-L382
    term_env = get(ENV, "TERM", @static Sys.iswindows() ? "" : "dumb")
    term = REPL.Terminals.TTYTerminal(term_env, stdin, stdout, stderr)
    have_color = REPL.Terminals.hascolor(term)
    if term.term_type == "dumb"
        # overwrite REPL.run_frontend(repl::BasicREPL)
        BasicREPL_INPUT_LINE_FUNC[] = repl_func
        active_repl = REPL.BasicREPL(term)
    else
        active_repl = REPL.LineEditREPL(term, have_color, true)
        active_repl.history_file = true

        # set prompt
        active_repl.interface = REPL.setup_interface(active_repl)
        main_mode = active_repl.interface.modes[1]
        main_mode.prompt = MAL_PROMPT
        main_mode.on_done = REPL.respond(repl_func, active_repl, main_mode)
    end
    pushdisplay(REPL.REPLDisplay(active_repl))

    REPL.run_repl(active_repl)
    end
end # end of start_repl()

end # module MalREPL

# # for test
# using .Mal_REPL
# start_repl()