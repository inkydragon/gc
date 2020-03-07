# debug help macro
const global debug = [false]
macro dbg(expr)
    :( debug[] && $(esc(expr)) )
end
# debug[] = true
#= Type def =#

"""
    MalType

## Primitive Types
+ MalNum    # number
+ MalSym    # Symbol, identifier

+ MalStr    # String
+ MalNil
+ MalBool   # Boolean
+ MalKeyword
+ MalComment
+ MalDeref

## Composite Types
+ MalList

+ MalQuote
+ MalUnquote
+ MalQuasiQuote
+ MalSpliceUnquote
+ MalVec
+ MalHash

+ MalMetadata

"""
abstract type MalType end
abstract type MalAtom <: MalType end
abstract type MalRec  <: MalType end

abstract type MalNum <: MalAtom end
struct MalInt <: MalAtom
    val :: Integer
end
struct MalFloat <: MalAtom
    val :: AbstractFloat
end

struct MalSym <: MalAtom # identifier
    val :: Symbol
end

struct MalStr <: MalAtom
    val :: AbstractString
end
struct MalNil <: MalAtom end
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



struct MalList <: MalRec
    val :: Vector{MalType}
    MalList() = new(Vector{MalType}())
end

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

struct MalVec <: MalRec
    val :: Vector{MalType}
    MalVec() = new(Vector{MalVec}())
end

const MAL_KEY_TYPE = Union{MalSym, MalStr, MalKeyword, MalInt, MalBool}
const MAL_HASH_DICT_TYPE = Dict{MAL_KEY_TYPE, MalType}
struct MalHash <: MalType
    val :: MAL_HASH_DICT_TYPE
    MalHash() = new(MAL_HASH_DICT_TYPE())
end

struct MalMetadata <: MalType
    val  :: MalType
    meta :: MalHash
end
