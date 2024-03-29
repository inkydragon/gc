# reader.jl

# mal_debug[] = true
const global mal_dbg_lex = [false]
const REGEX_TABLE = Dict(
    # 初步分割
    :whitespaces_commas  => raw"[\s,]*",
    :special_characters  => raw"~@",
    :special_single_char => raw"[\[\]{}()'`~^@]",
    :double_quote_string => raw"\"(?:\\.|[^\\\"])*\"?",
    :comments            => raw";.*",
    :identifier          => raw"""[^\s\[\]{}('"`,;)]*""",
    # :all_token => raw"""[\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\\"])*"?|;.*|[^\s\[\]{}('"`,;)]*)""",

    # lex 验证用
    :float       => raw"[+-]?([0-9]+\.[0-9]*|[0-9]*\.[0.9]+)",
    :integer     => raw"[+-]?[0-9]+",
    :string      => raw"\"((?:\\.|[^\\\"])*)\"",
)

"确保整个字符串都符合给定的 re"
const ONLY = re -> Regex(raw"^" * re * raw"$")

mutable struct Reader
    "储存 token 的数组"
    tokens :: Vector{AbstractString}
    "当前 token 位置"
    pos :: Int64

    function Reader(tks::Vector{AbstractString})
        new(tks, length(tks)>0 ? 1 : -1)
    end
end

"取出当前 pos 对应的 token。pos++"
function next(r::Reader)
    ret = peek(r)
    r.pos += isnothing(ret) ? 0 : 1
    ret
end

"取出当前 pos 对应的 token。越界返回 nothing"
function peek(r::Reader)
    if checkbounds(Bool, r.tokens, r.pos)
        r.tokens[r.pos]
    else
        nothing
    end
end

"取出一个 token，确保 token==tk。否则报错"
function eat(r::Reader, tk::AbstractString)
    head = next(r)
    head==tk || throw("[eat] need ($tk) but got ($head)")
    head
end

function read_str(program::AbstractString)
    program |> tokenize |> Reader |> read_form
end

"lex 将字符串分割为 tokens"
function tokenize(program::AbstractString)
    program = strip(program, ['\n', '\r'])
    isempty(program) && return AbstractString[""]

    # 正则表达式
    all_token = Regex(
        REGEX_TABLE[:whitespaces_commas] * 
        "(" * 
            REGEX_TABLE[:special_characters] * 
            "|" * REGEX_TABLE[:special_single_char] *
            "|" * REGEX_TABLE[:double_quote_string] *
            "|" * REGEX_TABLE[:comments] *
            "|" * REGEX_TABLE[:identifier] *
        ")"
    )

    tokens = AbstractString[]
    len = length(program)
    m = match(all_token, program)
    offset = m.offset
    while checkbounds(Bool, program, offset)
        # @dbg mal_dbg_lex[] && start_offset = offset+m.offsets[1] - 1
        # @dbg mal_dbg_lex[] && println(
        #     "'$program'm.match='$(m.match)'\n",
        #     " " ^ (start_offset),
        #     "$(m[:1])<=[$start_offset]",
        # )
        push!(tokens, m[:1])
        offset += length(m.match)
        m = match(all_token, program[offset:end])
    end
    # filter!(x->x!="", tokens)
    @dbg mal_dbg_lex[] && println(tokens)
    tokens
end

"主 lexer。根据首字母进行分派"
function read_form(reader::Reader)
    @dbg mal_dbg_lex[] && println("[header] $(peek(reader))")

    # rec data
    if startswith(peek(reader), "(")
        eat(reader, "(")
        read_list(reader)
    elseif startswith(peek(reader), "[")
        eat(reader, "[")
        read_vector(reader)
    elseif startswith(peek(reader), "{")
        eat(reader, "{")
        read_hash(reader)

    elseif startswith(peek(reader), "@")
        eat(reader, "@")
        read_deref(reader)
    elseif startswith(peek(reader), "^")
        eat(reader, "^")
        read_meta(reader)
    
    # eat start seq in functions
    elseif startswith(peek(reader), "'")
        read_quote(reader)
    elseif startswith(peek(reader), "`")
        read_quasiquote(reader)
    elseif startswith(peek(reader), "~@")
        read_splice_unquote(reader)
    elseif startswith(peek(reader), "~")
        read_unquote(reader)

    # default
    else
        read_atom(reader)
    end
end

# 事不过三
# function read_rec_ds(
#         reader::Reader, 
#         ::T, 
#         LP::String, 
#         RP::String
#     ) where T <: MalListLike
#     ds = MalList()
#     while !isnothing(peek(reader))
#         endswith(peek(reader), "$LP") && break
#         push!(ds.val, read_form(reader))
#     end
#     # 在读到 LP 之前遇到 EOF
#     isnothing(peek(reader)) && throw("[lex] unbalanced pair '$LP'.")
#     eat(reader, "$RP")

#     @dbg mal_dbg_lex[] && println("[$T] ret $ds")
#     ds
# end

function read_list(reader::Reader)
    list = MalList()
    while !isnothing(peek(reader))
        endswith(peek(reader), ")") && break
        push!(list, read_form(reader))
    end
    # 在读到 ")" 之前遇到 EOF
    isnothing(peek(reader)) && throw("[lex] unbalanced pair '('.")
    eat(reader, ")")

    @dbg mal_dbg_lex[] && println("[list] ret $list")
    list
end

function read_vector(reader::Reader)
    vec = MalVec()
    while !isnothing(peek(reader))
        endswith(peek(reader), "]") && break
        push!(vec, read_form(reader))
    end
    # 在读到 "]" 之前遇到 EOF
    isnothing(peek(reader)) && throw("[lex] unbalanced pair '['.")
    eat(reader, "]")

    @dbg mal_dbg_lex[] && println("[vec] ret $vec")
    vec
end

function read_hash(reader::Reader)
    hash = MalHash()
    while !isnothing(peek(reader))
        endswith(peek(reader), "}") && break
        key = read_atom(reader)
        val = read_form(reader)
        isnothing(val) && throw("[lex] unbalanced {k=>v} pair 'k=>?'.")
        push!(hash, key => val)
    end
    # 在读到 "}" 之前遇到 EOF
    isnothing(peek(reader)) && throw("[lex] unbalanced pair '{'.")
    eat(reader, "}")

    @dbg mal_dbg_lex[] && println("[hash] ret $hash")
    hash
end

function read_deref(reader::Reader)
    id = read_atom(reader)
    isnothing(id) && throw("[lex] unexpected EOF? 'deref ?'.")
    @dbg println("[deref] ret (deref $id)")
    MalDeref(id)
end

function read_meta(reader::Reader)
    tk = peek(reader)
    isnothing(tk) && throw("[lex] unexpected EOF? '^?'.")
    "{"==tk || throw("[lex] unexpected EOF? '^$tk'.")

    eat(reader, "{")
    hash = read_hash(reader)
    isnothing(hash) && throw("[lex] unexpected EOF? '^?'.")
    m = read_form(reader)
    isnothing(m)    && throw("[lex] unexpected EOF? '^{} ?'.")
    MalMetadata(m, hash)
end

function read_quotes(reader::Reader, ::Type{T}, start::String) where T<:MalType
    head = eat(reader, start)
    m = read_form(reader)
    isnothing(m) && throw("[lex] unexpected EOF? '$head?'.")
    T(m)
end
read_quote(r::Reader) = read_quotes(r, MalQuote, "'")
read_quasiquote(r::Reader) = read_quotes(r, MalQuasiQuote, "`")
read_splice_unquote(r::Reader) = read_quotes(r, MalSpliceUnquote, "~@")
read_unquote(r::Reader) = read_quotes(r, MalUnquote, "~")


#= `read_atom` help function =#
"lex 类标识符"
function match_id(tk::AbstractString)
    @assert occursin(ONLY(REGEX_TABLE[:identifier]), tk)

    if "nil" == tk
        # Nil
        MalNil()
    elseif "true" == tk || "false" == tk
        # Bool
        parse(Bool, tk) |> MalBool
    elseif startswith(tk, ":")
        # Keyword
        id_re = REGEX_TABLE[:identifier][1:end-1] # remove '*'
        kw_re = ":($id_re+)"
        m = match(ONLY(kw_re), tk)
        isnothing(m) && throw("[lex] EOF? illegal keyword? '$tk'.")
        m[:1] |> Symbol |> MalKeyword
    else
        # Symbol / identifier
        tk |> Symbol |> MalSym
    end
end

"lex String 并检查转义合法性"
function match_str(tk::AbstractString)
    @assert occursin(ONLY(REGEX_TABLE[:double_quote_string]), tk)

    m_err = match(r"(\\+)\"$", tk)
    m = match(ONLY(REGEX_TABLE[:string]), tk)
    if isnothing(m)
        # 引号未闭合
        @dbg mal_dbg_lex[] && println("($tk)")
        throw("[lex] unbalanced quote!")
    elseif !isnothing(m_err) && length(m_err[:1]) % 2 == 1
        # 末尾有奇数个 \, 转移了最后的引号
        throw("[lex] unbalanced escape! Can't esc last quote.")
    else
        # String
        m[:1] |> MalStr
    end
end

"lex 原子类型"
function read_atom(reader::Reader)
    tk = next(reader)
    @dbg mal_dbg_lex[] && println("read_atom: $tk")

    if isnothing(tk)
        nothing
    elseif occursin(ONLY(REGEX_TABLE[:integer]), tk)
        MalInt(parse(Int64, tk))
    elseif occursin(ONLY(REGEX_TABLE[:float]), tk)
        MalFloat(parse(Float64, tk))
    elseif occursin(ONLY(REGEX_TABLE[:double_quote_string]), tk)
        match_str(tk)
    elseif occursin(ONLY(REGEX_TABLE[:identifier]), tk)
        match_id(tk)
    elseif occursin(ONLY(REGEX_TABLE[:comments]), tk)
        @dbg mal_dbg_lex[] && println("ret MalComment")
        MalComment(tk)
    else
        throw("[read_atom] unknown token ($tk)")
    end
end
