# debug help macro
const global debug = [false]
macro dbg(expr)
    :( debug[] && $(esc(expr)) )
end

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
    val
end



struct MalList <: MalType
    val :: Vector{MalType}
    MalList() = new(Vector{MalType}())
end

struct MalQuote <: MalType
    val
end
struct MalUnquote <: MalType
    val
end
struct MalQuasiQuote <: MalType
    val
end
struct MalSpliceUnquote <: MalType
    val
end

struct MalVec <: MalType
    val :: Vector{MalType}
    MalVec() = new(Vector{MalVec}())
end
struct MalHash <: MalType
    val :: Dict
end

struct MalMetadata <: MalType
    meta :: MalHash
    val  :: MalType
end
