#= mal_debug help macro =#
const global mal_debug = [false]
macro dbg(expr)
    :( mal_debug[] && $(esc(expr)) )
end
# mal_debug[] = true


#= Type def =#
"""
    abstract type MalType end

abstract subtypes:
+ MalAtom
    MalNum
+ MalRec
    + MalListLike

## Primitive Types
+ MalInt    <: MalNum
+ MalFloat  <: MalNum
+ MalSym    # Symbol, identifier
+ MalStr    # String
+ MalNil
+ MalBool   # Boolean
+ MalKeyword
+ MalComment
+ MalDeref
+ MalFunc

## Composite Types
+ MalList   <: MalListLike
+ MalVec    <: MalListLike
+ MalHash   <: MalRec
+ MalQuote
+ MalUnquote
+ MalQuasiQuote
+ MalSpliceUnquote
+ MalMetadata
"""
abstract type MalType end
abstract type MalAtom <: MalType end
abstract type MalRec  <: MalType end
abstract type MalListLike <: MalRec end

## Primitive Types
abstract type MalNum <: MalAtom end
struct MalInt <: MalNum
    val :: Integer
end
struct MalFloat <: MalNum
    val :: AbstractFloat
end
struct MalSym <: MalAtom # identifier
    val :: Symbol
end
MalSym(s::AbstractString) = s |> Symbol |> MalSym
struct MalStr <: MalAtom
    val :: AbstractString
end
struct MalNil <: MalAtom end
MalNil(_) = MalNil()
struct MalBool <: MalAtom
    val :: Bool
end
struct MalKeyword <: MalAtom
    val :: Symbol
end
struct MalComment <: MalAtom
    val :: AbstractString
end
struct MalDeref <: MalAtom
    val :: MalSym
end

struct MalFunc <: MalAtom
    val :: Function
end

struct MalNothing <: MalAtom end
MalNothing(_...) = MalNothing()

## Composite Types
struct MalList <: MalListLike
    val :: Vector{MalType}
end
MalList() = MalList(MalType[])
MalList(m::MalType) = MalList(MalType[m])
MalList(tup::Tuple) = collect(MalType, tup) |> MalList

struct MalVec <: MalListLike
    val :: Vector{MalType}
end
MalVec() = MalVec(MalType[])
MalVec(m::MalType) = MalVec(MalType[m])
MalVec(tup::Tuple) = collect(MalType, tup) |> MalVec

const MAL_KEY_TYPE = Union{MalSym, MalStr, MalKeyword, MalInt, MalBool}
const MAL_HASH_DICT_TYPE = Dict{MAL_KEY_TYPE, MalType}
struct MalHash <: MalRec
    val :: MAL_HASH_DICT_TYPE
end
MalHash() = MalHash(MAL_HASH_DICT_TYPE())

# quotes
struct MalQuote <: MalType
    val :: MalType
end
struct MalUnquote <: MalType
    val:: MalType
end
struct MalQuasiQuote <: MalType
    val:: MalType
end
struct MalSpliceUnquote <: MalType
    val:: MalType
end

struct MalMetadata <: MalType
    val  :: MalType
    meta :: MalHash
end


## useful functions

## MalRec
# iterate
Base.isempty(m::MalRec)         = isempty(m.val)
Base.isempty(::MalNil)          = true
Base.length(m::MalRec)          = length(m.val)
Base.length(m::MalNil)          = 0
Base.iterate(m::MalRec)         = iterate(m.val)
Base.iterate(m::MalRec, idx)    = iterate(m.val, idx)
Base.eltype(::Type{<:MalListLike})  = MalType
Base.eltype(::Type{MalHash})        = Pair{MAL_KEY_TYPE, MalType}
# index
Base.getindex(m::MalRec, i)     = getindex(m.val, i)
Base.setindex!(m::MalRec, v, i) = setindex!(m.val, v, i)
Base.firstindex(m::MalRec)      = firstindex(m.val)
Base.lastindex(m::MalRec)       = lastindex(m.val)

## MalListLike
Base.size(m::MalListLike) = size(m.val)
Base.push!(m::MalListLike, item) = push!(m.val, item)
Base.append!(m::MalListLike, items::AbstractVector) = append!(m.val, items)

## MalHash
Base.get(d::Dict, k::MAL_KEY_TYPE, default) = get(d, k.val, default)
Base.get(h::MalHash, key, default) = get(h.val, key, default)
Base.get(h::MalHash, k::MAL_KEY_TYPE, default) =
    get(h.val, k.val, default)
Base.push!(h::MalHash, p::Pair) = push!(h.val, p)

## MalFunc
# +, -, *, div
for op in (:+, :-, :*)
    @eval begin
        Base.$op(x::MalFloat, y::T) where T<:MalNum = MalFloat($op(x.val, y.val))
        Base.$op(x::MalInt,   y::MalFloat) = $op(y, x)
        Base.$op(x::MalInt,   y::MalInt)   = MalInt($op(x.val, y.val))
    end
end
Base.:div(x::MalInt, y::MalInt) = MalInt(div(x.val, y.val))

# isequal
Base.:(==)(m1::T1, m2::T2) where {T1<:MalType, T2<:MalType} =
    T1==T2 &&
    typeof(m1.val)==typeof(m2.val) &&
    isequal(m1.val, m2.val)
Base.:(==)(m1::T1, m2::T2) where {T1<:MalListLike, T2<:MalListLike} =
    (0==length(m1)==length(m2)) ||
    length(m1)==length(m2) &&
    isequal(m1.val, m2.val)
Base.:(==)(::MalNil, ::T) where {T<:MalType} = MalNil==T
Base.:(==)(::MalNil, ::MalNil) = true
for op in (:>, :<, :(>=), :(<=))
    @eval begin
        Base.$op(x::MalNum, y::MalNum) = MalBool($op(x.val, y.val))
    end
end