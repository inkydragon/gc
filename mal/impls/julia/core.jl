# core.jl

_mal_eq(m1::T1, m2::T2) where {T1<:MalType, T2<:MalType} =
    (m1==m2) |> MalBool
_mal_ne(m1::T1, m2::T2) where {T1<:MalType, T2<:MalType} =
    !(m1==m2) |> MalBool

_mal_pr_str(mals::MalType...) =
    join([pr_str(m,true)  for m in mals], " ") |>
        MalStr
_mal_str(mals::MalType...) =
    join([pr_str(m,false) for m in mals], " ") |>
        MalStr
_mal_prn(mals::MalType...) =
    join([pr_str(m,true)  for m in mals], " ") |>
        println |> MalNil
_mal_println(mals::MalType...) =
    join([pr_str(m,false) for m in mals], " ") |>
        println |> MalNil

_mal_list()                 = MalList()
_mal_list(m::MalType)       = m |> MalList
_mal_list(m::MalType...)    = [m...] |> MalList
_mal_is_list(m::MalType)    = (m isa MalList) |> MalBool
_mal_is_empty(m::MalType)   = m |> isempty |> MalBool
_mal_count(m::MalType)      = m |> length |> MalInt

const ns = MalEnv(
    :+ => +,
    :- => -,
    :* => *,
    :/ => div,
    :< => <,
    :> => >,
    :(<=) => (<=),
    :(>=) => (>=),
    :(=)  => _mal_eq,
    :(!=) => _mal_ne,

    # print
    Symbol("pr-str")  => _mal_pr_str,
    Symbol("str")     => _mal_str,
    Symbol("prn")     => _mal_prn,
    Symbol("println") => _mal_println,

    # list
    Symbol("list")    => _mal_list,
    Symbol("list?")   => _mal_is_list,
    Symbol("empty?")  => _mal_is_empty,
    Symbol("count")   => _mal_count,
) # MalEnv end