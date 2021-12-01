const EnvDict = Dict{MAL_KEY_TYPE, MalType}
mutable struct MalEnv
    data  :: EnvDict
    outer :: Union{MalEnv, Nothing}

    function MalEnv(data, outer=nothing)
        new(data, outer)
    end
end
MalEnv(outer::Union{MalEnv, Nothing}=nothing) =
    MalEnv(EnvDict(), outer)
MalEnv(data::EnvDict) = MalEnv(data, nothing)
MalEnv(p::Pair{Symbol,<:Function}...) =
    [MalSym(s)=>MalFunc(f) for (s,f) in p] |>
        EnvDict |> MalEnv
# MalEnv(
#     binds::MalListLike, 
#     exprs::MalListLike, 
#     outer::Union{MalEnv, Nothing}=nothing
# ) = zip(binds.val,exprs.val) |> EnvDict |> d->MalEnv(d,outer)
function MalEnv(
    binds::MalListLike, 
    exprs::MalListLike, 
    outer::Union{MalEnv, Nothing}=nothing
)
    env = MalEnv(outer)
    for i in 1:length(binds)
        bind = binds[i]

        if MalSym("&")!=bind
            env[bind] = exprs[i]
            continue
        end

        # (fn*  <binds>             <exprs>       )
        # (fn* (<...> <i-&> <i+1>) (<...> <i:end>))
        bind = binds[i+1]
        expr = exprs[i:end] |> MalList
        env[bind] = expr
        break
    end
    env
end

Base.setindex!(env::MalEnv, v::MalType, k::MAL_KEY_TYPE) =
    env.data[k] = v
set(env::MalEnv, k::MAL_KEY_TYPE, v::MalType) = env[k] = v

function find(env::MalEnv, k::MAL_KEY_TYPE)
    haskey(env.data, k) ? env : find(env.outer, k)
end
find(::Nothing, _) = nothing

function Base.get(env::MalEnv, k::MAL_KEY_TYPE)
    mal_env = find(env, k)
    isnothing(mal_env) && throw("[env] symbol '$k' not found!")
    mal_env.data[k]
end
Base.getindex(env::MalEnv, k::MAL_KEY_TYPE) = get(env, k)
Base.getindex(env::MalEnv, k::Symbol) = get(env, MalSym(k))
