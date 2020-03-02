module Mal_REPL

# for script without REPL
import REPL
import REPL.LineEdit
import REPL: 
    AbstractREPL, REPLBackendRef, # run_repl
    REPLBackend, # start_repl_backend
    catch_stack, # eval_user_input
    LineEditREPL, REPLDisplay, terminal, # run_frontend
    # setup_interface
    REPLCompletionProvider, REPLHistoryProvider, find_hist_file, 
    hist_from_file, print_response, outstream, history_reset_state,
    respond, repl_filename, LatexCompletions, AnyDict,
    mode_keymap
import REPL.LineEdit: 
    run_interface, # run_frontend
    Prompt, ModalInterface # setup_interface

# for Julia's REPL
using ReplMaker

const IN_JULIA_REPL = isdefined(Base, :active_repl)
const NOT_IN_JULIA_REPL = ! IN_JULIA_REPL
const MAL_PROMPT = "user> "



# 全局处理函数
EVAL_MAL_EXPR = identity

export start_repl, IN_JULIA_REPL, EVAL_MAL_EXPR

#= COPY FROM `REPL.jl` && `client.jl`
    + small modify
=#

# stdlib/REPL.jl#L196-L203 [未修改]
# => start_repl_backend, run_frontend
function run_repl(repl::AbstractREPL, @nospecialize(consumer = x -> nothing))
    repl_channel = Channel(1)
    response_channel = Channel(1)
    backend = start_repl_backend(repl_channel, response_channel)
    consumer(backend)
    run_frontend(repl, REPLBackendRef(repl_channel, response_channel))
    return backend
end

# stdlib/REPL.jl#L105-L122 [未修改]
# => eval_user_input
function start_repl_backend(repl_channel::Channel, response_channel::Channel)
    backend = REPLBackend(repl_channel, response_channel, false)
    backend.backend_task = @async begin
        # include looks at this to determine the relative include path
        # nothing means cwd
        while true
            tls = task_local_storage()
            tls[:SOURCE_PATH] = nothing
            ast, show_value = take!(backend.repl_channel)
            if show_value == -1
                # exit flag
                break
            end
            REPL.eval_user_input(ast, backend) # 使用原版函数
        end
    end
    return backend
end

# stdlib/REPL.jl#L76-L103
# 两处修改：
#   + value = EVAL_MAL_EXPR(ast)
#   + 注释了 ans 变量的设置
#=
function eval_user_input(@nospecialize(ast), backend::REPLBackend)
    lasterr = nothing
    Base.sigatomic_begin()
    while true
        try
            Base.sigatomic_end()
            if lasterr !== nothing
                put!(backend.response_channel, (lasterr,true))
            else
                backend.in_eval = true
                value = Core.eval(Main, ast)
    #= 1> =#    #value = EVAL_MAL_EXPR(ast)
                backend.in_eval = false
                # note: use jl_set_global to make sure value isn't passed through `expand`
    #= 2> =#    # ccall(:jl_set_global, Cvoid, (Any, Any, Any), Main, :ans, value)
                put!(backend.response_channel, (value,false))
            end
            break
        catch err
            if lasterr !== nothing
                println("SYSTEM ERROR: Failed to report error to REPL frontend")
                println(err)
            end
            lasterr = catch_stack()
        end
    end
    Base.sigatomic_end()
    nothing
end
=#

# stdlib/REPL.jl#L1034-L1048  [未修改]
# => setup_interface, LineEdit.init_state, run_interface
function run_frontend(repl::LineEditREPL, backend::REPLBackendRef)
    d = REPLDisplay(repl)
    dopushdisplay = repl.specialdisplay === nothing && !in(d,Base.Multimedia.displays)
    dopushdisplay && pushdisplay(d)
    if !isdefined(repl,:interface)
        interface = repl.interface = setup_interface(repl)
    else
        interface = repl.interface
    end
    repl.backendref = backend
    repl.mistate = LineEdit.init_state(terminal(repl), interface)
    run_interface(terminal(repl), interface, repl.mistate)
    dopushdisplay && popdisplay(d)
    nothing
end

# [未修改]
function return_callback(s)
    ast = Base.parse_input_line(String(take!(copy(LineEdit.buffer(s)))), depwarn=false)
    return !(isa(ast, Expr) && ast.head === :incomplete)
end

# stdlib/REPL.jl#L764-L1032
# 多处修改：
# + 删除 shell mode 相关的代码
# + z注释 help mode 的代码
# + 改 julia_prompt 未 mal_prompt
setup_interface(
    repl::LineEditREPL;
    # those keyword arguments may be deprecated eventually in favor of the Options mechanism
    hascolor::Bool = repl.options.hascolor,
    extra_repl_keymap::Any = repl.options.extra_keymap
) = setup_interface(repl, hascolor, extra_repl_keymap)

# This non keyword method can be precompiled which is important
function setup_interface(
    repl::LineEditREPL,
    hascolor::Bool,
    extra_repl_keymap::Any, # Union{Dict,Vector{<:Dict}},
)
    # The precompile statement emitter has problem outputting valid syntax for the
    # type of `Union{Dict,Vector{<:Dict}}` (see #28808).
    # This function is however important to precompile for REPL startup time, therefore,
    # make the type Any and just assert that we have the correct type below.
    @assert extra_repl_keymap isa Union{Dict,Vector{<:Dict}}

    ###
    # We setup the interface in two stages.
    # First, we set up all components (prompt,rsearch,shell,help)
    # Second, we create keymaps with appropriate transitions between them
    #   and assign them to the components
    #
    ###

    ############################### Stage I ################################

    # This will provide completions for REPL and help mode
    replc = REPLCompletionProvider()

    # Set up the main Julia prompt
    mal_prompt = Prompt(
            MAL_PROMPT;
            # Copy colors from the prompt object
            prompt_prefix = hascolor ? repl.prompt_color : "",
            prompt_suffix = hascolor ?
                (repl.envcolors ? Base.input_color : repl.input_color) : "",
            repl = repl,
            complete = replc,
            on_enter = return_callback
        )

    # Setup help mode
#= TODO: add `helpmode`
    help_mode = Prompt("help?> ",
        prompt_prefix = hascolor ? repl.help_color : "",
        prompt_suffix = hascolor ?
            (repl.envcolors ? Base.input_color : repl.input_color) : "",
        repl = repl,
        # When we're done transform the entered line into a call to help("$line")
        on_done = respond(helpmode, repl, mal_prompt, pass_empty=true))
=#

    ################################# Stage II #############################

    # Setup history
    # We will have a unified history for all REPL modes
    hp = REPLHistoryProvider(Dict{Symbol,Any}(
            # :help  => help_mode,
            :julia => mal_prompt
        ))
    if repl.history_file
        try
            hist_path = find_hist_file()
            mkpath(dirname(hist_path))
            f = open(hist_path, read=true, write=true, create=true)
            finalizer(replc) do replc
                close(f)
            end
            hist_from_file(hp, f, hist_path)
        catch
            print_response(repl, (catch_stack(),true), true, Base.have_color)
            println(outstream(repl))
            @info "Disabling history file for this session"
            repl.history_file = false
        end
    end
    history_reset_state(hp)
    mal_prompt.hist = hp
    # help_mode.hist = hp

    # _func = x -> Base.parse_input_line(x, filename=repl_filename(repl,hp))
    _func= EVAL_MAL_EXPR
    mal_prompt.on_done = respond(_func, repl, mal_prompt)

    search_prompt, skeymap = LineEdit.setup_search_keymap(hp)
    search_prompt.complete = LatexCompletions()

    # Canonicalize user keymap input
    if isa(extra_repl_keymap, Dict)
        extra_repl_keymap = [extra_repl_keymap]
    end

    repl_keymap = AnyDict(
        # help mode
    #=
        '?' => function (s,o...)
            if isempty(s) || position(LineEdit.buffer(s)) == 0
                buf = copy(LineEdit.buffer(s))
                transition(s, help_mode) do
                    LineEdit.state(s, help_mode).input_buffer = buf
                end
            else
                edit_insert(s, '?')
            end
        end,
    =#

        # Bracketed Paste Mode
        # [包围粘贴模式](https://cirw.in/blog/bracketed-paste)
    #=
        "\e[200~" => (s,o...)->begin
            input = LineEdit.bracketed_paste(s) # read directly from s until reaching the end-bracketed-paste marker
            sbuffer = LineEdit.buffer(s)
            curspos = position(sbuffer)
            seek(sbuffer, 0)
            shouldeval = (bytesavailable(sbuffer) == curspos && !occursin(UInt8('\n'), sbuffer))
            seek(sbuffer, curspos)
            if curspos == 0
                # if pasting at the beginning, strip leading whitespace
                input = lstrip(input)
            end
            if !shouldeval
                # when pasting in the middle of input, just paste in place
                # don't try to execute all the WIP, since that's rather confusing
                # and is often ill-defined how it should behave
                edit_insert(s, input)
                return
            end
            LineEdit.push_undo(s)
            edit_insert(sbuffer, input)
            input = String(take!(sbuffer))
            oldpos = firstindex(input)
            firstline = true
            isprompt_paste = false
            jl_prompt_len = 7 # "julia> "
            while oldpos <= lastindex(input) # loop until all lines have been executed
                if JL_PROMPT_PASTE[]
                    # Check if the next statement starts with "julia> ", in that case
                    # skip it. But first skip whitespace
                    while input[oldpos] in ('\n', ' ', '\t')
                        oldpos = nextind(input, oldpos)
                        oldpos >= sizeof(input) && return
                    end
                    # Check if input line starts with "julia> ", remove it if we are in prompt paste mode
                    if (firstline || isprompt_paste) && startswith(SubString(input, oldpos), MAL_PROMPT)
                        isprompt_paste = true
                        oldpos += jl_prompt_len
                    # If we are prompt pasting and current statement does not begin with julia> , skip to next line
                    elseif isprompt_paste
                        while input[oldpos] != '\n'
                            oldpos = nextind(input, oldpos)
                            oldpos >= sizeof(input) && return
                        end
                        continue
                    end
                end
                ast, pos = Meta.parse(input, oldpos, raise=false, depwarn=false)
                if (isa(ast, Expr) && (ast.head === :error || ast.head === :incomplete)) ||
                        (pos > ncodeunits(input) && !endswith(input, '\n'))
                    # remaining text is incomplete (an error, or parser ran to the end but didn't stop with a newline):
                    # Insert all the remaining text as one line (might be empty)
                    tail = input[oldpos:end]
                    if !firstline
                        # strip leading whitespace, but only if it was the result of executing something
                        # (avoids modifying the user's current leading wip line)
                        tail = lstrip(tail)
                    end
                    if isprompt_paste # remove indentation spaces corresponding to the prompt
                        tail = replace(tail, r"^"m * ' '^jl_prompt_len => "")
                    end
                    LineEdit.replace_line(s, tail, true)
                    LineEdit.refresh_line(s)
                    break
                end
                # get the line and strip leading and trailing whitespace
                line = strip(input[oldpos:prevind(input, pos)])
                if !isempty(line)
                    if isprompt_paste # remove indentation spaces corresponding to the prompt
                        line = replace(line, r"^"m * ' '^jl_prompt_len => "")
                    end
                    # put the line on the screen and history
                    LineEdit.replace_line(s, line)
                    LineEdit.commit_line(s)
                    # execute the statement
                    terminal = LineEdit.terminal(s) # This is slightly ugly but ok for now
                    raw!(terminal, false) && disable_bracketed_paste(terminal)
                    LineEdit.mode(s).on_done(s, LineEdit.buffer(s), true)
                    raw!(terminal, true) && enable_bracketed_paste(terminal)
                    LineEdit.push_undo(s) # when the last line is incomplete
                end
                oldpos = pos
                firstline = false
            end
        end,
    =#
    )

    prefix_prompt, prefix_keymap = LineEdit.setup_prefix_keymap(hp, mal_prompt)

    a = Dict{Any,Any}[skeymap, repl_keymap, prefix_keymap, LineEdit.history_keymap, LineEdit.default_keymap, LineEdit.escape_defaults]
    prepend!(a, extra_repl_keymap)

    mal_prompt.keymap_dict = LineEdit.keymap(a)

    mk = mode_keymap(mal_prompt)

    b = Dict{Any,Any}[skeymap, mk, prefix_keymap, LineEdit.history_keymap, LineEdit.default_keymap, LineEdit.escape_defaults]
    prepend!(b, extra_repl_keymap)

    # help_mode.keymap_dict = LineEdit.keymap(b)

    allprompts = [mal_prompt, #=help_mode,=# search_prompt, prefix_prompt]
    return ModalInterface(allprompts)
end
#= COPY END ================================================ =#


"""
从 Julia 的 REPL 里启动 MAL 的 REPL。包含 LineEdit 功能。

注意：需要从 julia 的 REPL 里启动。
"""
function start_repl(repl_func::Function=identity)
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
        #=
            Julia’s REPL v1.3.1

            _start() @base/client.jl#L452
            =>  exec_options() @base/client.jl#L213
            =>  run_main_repl() @base/client.jl#L351
            =>  run_repl() @stdlib/REPL.jl#L196
                =>  start_repl_backend() @stdlib/REPL.jl#L105
                    =>  eval_user_input() @stdlib/REPL.jl#L76
                =>  run_frontend() @stdlib/REPL.jl#L1034
                    =>  setup_interface() @stdlib/REPL.jl#L772
                    =>  init_state() @stdlib/REPL/LineEdit.jl#L2290
                    =>  run_interface() @stdlib/REPL/LineEdit.jl#L2299
        =#
    # copy from: base/client.jl#L367-L382
    term_env = get(ENV, "TERM", @static Sys.iswindows() ? "" : "dumb")
    term = REPL.Terminals.TTYTerminal(term_env, stdin, stdout, stderr)
    # have_color = REPL.Terminals.hascolor(term)
    have_color = false
    # if term.term_type == "dumb"
    #     active_repl = REPL.BasicREPL(term)
    # else
    #     active_repl = REPL.LineEditREPL(term, have_color, true)
    #     active_repl.history_file = true
    # end
    active_repl = REPL.LineEditREPL(term, have_color, true)
    active_repl.history_file = true
    # Make sure any displays pushed in .julia/config/startup.jl ends up above the REPLDisplay
    pushdisplay(REPL.REPLDisplay(active_repl))


    EVAL_MAL_EXPR = repl_func
    # 强行去掉 prompt 的加粗
    Base.text_colors[:bold] = ""
    run_repl(active_repl)
    end
end # end of start_repl()

end # end of module Mal_REPL

# using .Mal_REPL
# start_repl()