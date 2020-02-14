function velocity!(uv::Array{Float64,2},
    u::Array{Float64,2}, v::Array{Float64,2})
    # @assert size(uv)==size(u) && size(u)==size(v)
    # @. uv = sqrt(u^2 + v^2)
    for i in length(uv[:])
        uv[i] = sqrt(u[i] + v[i])
    end
    uv
end

function velocity2!(uv::Array{Float64,2},
    u::Array{Float64,2}, v::Array{Float64,2})
    @. uv = sqrt(u^2 + v^2)
    uv
end

function velocity3!(uv::Array{Float64,2},
    u::Array{Float64,2}, v::Array{Float64,2})
    @. uv[:] = sqrt(u[:]^2 + v[:]^2)
    uv
end

# err!
# function velocity4!(uv::Array{Float64,2},
#     u::Array{Float64,2}, v::Array{Float64,2})
#     @. uv[:] = sqrt(u^2 + v^2)
#     uv
# end
# 
# function velocity5!(uv::Array{Float64,2},
#     u::Array{Float64,2}, v::Array{Float64,2})
#     uv[:] .= sqrt.(u.^2 .+ v.^2)
#     uv
# end

const nx = 1200
const ny = 600

uv = Array{Float64}(undef, nx, ny);
u = rand(Float64, nx, ny);
v = rand(Float64, nx, ny);
