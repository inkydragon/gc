include("Parserc/src/Parserc.jl")
using MLStyle
using .Parserc

@data Lisp begin
    Defun(Symbol, Vector{Symbol}, Lisp)
    Atom(Union{Symbol, String, Number})
    List(Vector{Lisp})
end


lexer_table = [
    :parens => function (str, offset)
        let c = str[offset]
            c in ('(', ')') ? String([c]) : nothing
        end
    end,

    :identifier => let ident_regex = r"\G[a-zA-Z_]{1}[a-zA-Z_0-9]*"
        function (str, offset)
            res = match(ident_regex, str, offset)
            res === nothing ? nothing : res.match
        end
    end,

    :space => let space_regex = r"\G\s"
        function (str, offset)
            res = match(space_regex, str, offset)
            res === nothing ? nothing : res.match
        end
    end,

    :number => let number_regex = r"\G0[Xx][\da-fA-F]+|\d+(?:\.\d+|)(?:E\-{0,1}\d+|)"
        function (str, offset)
            res = match(number_regex, str, offset)
            res === nothing ? nothing : res.match
        end
    end,

    :str => let str_regex = r"\G[A-Z]\'([^\\\']+|\\.)*?\'|\'([^\\\']+|\\.)*?\'"
        function (str, offset)
            res = match(str_regex, str, offset)
            res === nothing ? nothing : res.match
        end
    end
]


function lex_lisp(text, filename = "<repl>")
    tokens = lex(
        text,
        convert(Vector{Pair{Symbol, Function}}, lexer_table),
        Dict{String, Symbol}("defun" => :keyword),
        filename
    ) |> collect

    convert(Vector{Token}, filter(tokens) do token
        token.typ !== :space
    end)
end


const pl = literal(token -> token.typ === :parens && token.val === "(")
const pr = literal(token -> token.typ === :parens && token.val === ")")
const atom = literal(token -> !(token.typ in (:parens, :keyword))) ⇒ Fn{Token, Lisp}(
    token -> Atom(
    @match (token.typ,  token.val) begin
        (:str, a) => throw("not impl")
        (:number, a) => Base.parse(Int, a)
        (:identifier, a) => Symbol(a)
    end)
)

list_() = Parser{Lisp}(
    stream ->
    let elts = lisp[0, ∞] ⇒ Fn{Vector{Lisp}, Lisp}(List)
        (pl >> elts << pr)(stream)
    end
)

const list = list_()
const defun = Parser{Lisp}(
    stream ->
    let p_defun = literal(token -> token.typ === :keyword && token.val === "defun"),
        p_symbol = literal_by_type(:identifier) ⇒ Fn{Token, Symbol}(x -> Symbol(x.val)),
        p_args = pl >> p_symbol[0, ∞] << pr, # (a b c d)
        fn = Fn{Tuple{Tuple{Symbol, Vector{Symbol}}, Lisp}, Lisp}(
                (((fn_name, args), ret), ) ->
                 Defun(fn_name, args, ret)
        )
        (pl >> p_defun >> p_symbol & p_args & lisp << pr ⇒ fn)(stream)
    end
)

const lisp = atom | list | defun

function parse_lisp(tokens) :: Lisp
    res, remained = Parserc.parse(lisp, tokens)
    if !isempty(remained) || res === nothing
        throw("parsing failed")
    end
    res.value
end

eval_lisp(exp :: Lisp, ctx :: Dict{Symbol, Any}) =
    @match exp begin
        Defun(name :: Symbol, args :: Vector{Symbol}, ret :: Lisp) =>
            # (defun f (a b) (add a b))
             # (f 1 2)
             # [1, 2] `zip` [:a, :b]
             # Dict(ctx..., [:a => 1, :b => 2]...)
            begin
                f = function inner_func(inp_args)
                    let ctx =
                        Dict{Symbol, Any}(
                            ctx...,
                            (arg => inp_arg for (arg, inp_arg) in zip(args, inp_args))...,
                        )
                    first(eval_lisp(ret, ctx))
                    end
                end
                ctx = Dict{Symbol, Any}(name => f, ctx...)
                (f, ctx)
            end
        Atom(lit :: Union{String, Number}) => (lit, ctx)
        Atom(sym :: Symbol) => (ctx[sym], ctx)
        List([]) => (nothing, ctx)
        List([hd, tl...]) => let (hd, ctx) = eval_lisp(hd, ctx)
            args = map(tl) do each
                arg, ctx = eval_lisp(each, ctx)
                arg
            end
            (hd(args), ctx)
        end
    end

function main()
    ctx = Dict{Symbol, Any}(
        :add => sum,
        :sub => args -> args[1] - args[2]
    )
    res1, ctx = eval_lisp(parse_lisp(lex_lisp("(add 1 2)", "repl")), ctx)
    _, ctx = eval_lisp(parse_lisp(lex_lisp("(defun add3 (x) (add x 3))", "repl")), ctx)
    res2, ctx = eval_lisp(parse_lisp(lex_lisp("(add3 4)", "repl")), ctx)
    println(res1, "  ", res2)
end

main()
