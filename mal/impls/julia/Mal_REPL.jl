module Mal_REPL

using ReplMaker

export start_repl, IN_JULIA_REPL

const IN_JULIA_REPL = isdefined(Base, :active_repl)
const NOT_IN_JULIA_REPL = ! IN_JULIA_REPL

"""
从 Julia 的 REPL 里启动 MAL 的 REPL。包含 LineEdit 功能。

注意：需要从 julia 的 REPL 里启动。
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
            # keymap::Dict = REPL.LineEdit.default_keymap_dict,
            # completion_provider = REPL.REPLCompletionProvider(),
            # sticky_mode = true,
            startup_text = false
        )
    else # NOT_IN_JULIA_REPL
        @error "You should use mal in julia's REPL now!"
        exit(-1)
    end
end

end