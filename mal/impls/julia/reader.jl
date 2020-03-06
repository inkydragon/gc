include("types.jl")
# debug[] = true
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
const ONLY = s -> Regex(raw"^" * s * raw"$")

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
    r.pos += ret!=nothing ? 1 : 0
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

function eat(r::Reader, tk::AbstractString)
    head = next(r)
    head==tk || throw("[eat] need ($tk) but got ($head)")
end

function read_str(program::AbstractString)
    program |> tokenize |> Reader |> read_form

end

"lex 将字符串分割为 tokens"
function tokenize(program::AbstractString)
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
        # @dbg start_offset = offset+m.offsets[1] - 1
        # @dbg println(
        #     "'$program'm.match='$(m.match)'\n",
        #     " " ^ (start_offset),
        #     "$(m[:1])<=[$start_offset]",
        # )
        push!(tokens, m[:1])
        offset += length(m.match)
        m = match(all_token, program[offset:end])
    end
    @dbg println(tokens)
    tokens
end

function read_form(reader::Reader)
    @dbg println("[header] $(peek(reader))")
    if startswith(peek(reader), "(")
        eat(reader, "(")
        read_list(reader)
    elseif startswith(peek(reader), "[")
        eat(reader, "[")
        read_vector(reader)
    else
        read_atom(reader)
    end
end

function read_list(reader::Reader)
    list = MalList()
    while !isnothing(peek(reader))
        endswith(peek(reader), ")") && break
        push!(list.val, read_form(reader))
    end
    # 在读到 ")" 之前遇到 EOF
    isnothing(peek(reader)) && throw("[lex] unbalanced pair '('.")
    eat(reader, ")")

    @dbg println("[list] ret $list")
    list
end

function read_vector(reader::Reader)
    vec = MalVec()
    while !isnothing(peek(reader))
        endswith(peek(reader), "]") && break
        push!(vec.val, read_form(reader))
    end
    # 在读到 "]" 之前遇到 EOF
    isnothing(peek(reader)) && throw("[lex] unbalanced pair '['.")
    eat(reader, "]")

    @dbg println("[vec] ret $vec")
    vec
end

#= `read_atom` help function =#
function match_id(tk::AbstractString)
    @assert occursin(ONLY(REGEX_TABLE[:identifier]), tk)
    
    if "nil" == tk
        return MalNil()
    elseif "true" == tk || "false" == tk
        return parse(Bool, "true") |> MalBool
    else
        return tk |> Symbol |> MalSym
    end
end

function match_str(tk::AbstractString)
    @assert occursin(ONLY(REGEX_TABLE[:double_quote_string]), tk)

    m_err = match(r"(\\+)\"$", tk)
    m = match(ONLY(REGEX_TABLE[:string]), tk)
    if isnothing(m) # 引号未闭合
        @dbg "($tk)"
        throw("[lex] unbalanced quote!")
    elseif !isnothing(m_err) && length(m_err[:1]) % 2 == 1
        # 末尾有奇数个 \, 转移了最后的引号
        throw("[lex] unbalanced escape! Can't esc last quote.")
    else
        m[:1] |> MalStr
    end
end

function read_atom(reader::Reader)
    tk = next(reader)

    if occursin(ONLY(REGEX_TABLE[:integer]), tk)
        return MalInt(parse(Int64, tk))
    elseif occursin(ONLY(REGEX_TABLE[:float]), tk)
        return MalFloat(parse(Float64, tk))
    elseif occursin(ONLY(REGEX_TABLE[:double_quote_string]), tk)
        return match_str(tk)
    elseif occursin(ONLY(REGEX_TABLE[:identifier]), tk)
        return match_id(tk)
    else
        @error "[read_atom] unknown token ($tk)"
        exit(-1)
    end
end
