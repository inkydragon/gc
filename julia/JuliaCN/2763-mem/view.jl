
const nx = 1200
const ny = 600
const Q = 8
f = rand(Int, nx, ny, Q);

function r0!(f) # original
    @views f[:, ny, 4] = f[:, ny, 2]
    @views f[:, ny, 8] = f[:, ny, 6]
    @views f[:, ny, 7] = f[:, ny, 5]
end # 7.767 μs (9 allocations: 28.88 KiB)

function r1!(f) # nothing
    f[:, ny, 4] = f[:, ny, 2]
    f[:, ny, 8] = f[:, ny, 6]
    f[:, ny, 7] = f[:, ny, 5]
end # 6.140 μs (3 allocations: 28.50 KiB)

function r2!(f) # dot macro `@.` only
    @. f[:, ny, 4] = f[:, ny, 2]
    @. f[:, ny, 8] = f[:, ny, 6]
    @. f[:, ny, 7] = f[:, ny, 5]
end # 3.600 μs (6 allocations: 28.69 KiB)

function r3!(f) # dot only
    f[:, ny, 4] .= f[:, ny, 2]
    f[:, ny, 8] .= f[:, ny, 6]
    f[:, ny, 7] .= f[:, ny, 5]
end # 3.686 μs (6 allocations: 28.69 KiB)

# @. @views
function r4!(f) # @. @views
    @. @views f[:, ny, 4] = f[:, ny, 2]
    @. @views f[:, ny, 8] = f[:, ny, 6]
    @. @views f[:, ny, 7] = f[:, ny, 5]
end # 1.230 μs (6 allocations: 384 bytes)

function r5!(f) # @views @.
    @views @. f[:, ny, 4] = f[:, ny, 2]
    @views @. f[:, ny, 8] = f[:, ny, 6]
    @views @. f[:, ny, 7] = f[:, ny, 5]
end # 1.210 μs (6 allocations: 384 bytes)

function r6!(f) # add .
    @views f[:, ny, 4] .= f[:, ny, 2]
    @views f[:, ny, 8] .= f[:, ny, 6]
    @views f[:, ny, 7] .= f[:, ny, 5]
end # 1.230 μs (6 allocations: 384 bytes)

function r7!(f) # add .
    copy!(f[:, ny, 4], f[:, ny, 2])
    copy!(f[:, ny, 8], f[:, ny, 6])
    copy!(f[:, ny, 7], f[:, ny, 5])
end # 6.750 μs (6 allocations: 57.00 KiB)

# julia> @btime r0!($f);
#   7.767 μs (9 allocations: 28.88 KiB)
# julia> @btime r1!($f);
#   6.140 μs (3 allocations: 28.50 KiB)
# julia> @btime r2!($f);
#   3.600 μs (6 allocations: 28.69 KiB)
# julia> @btime r3!($f);
#   3.686 μs (6 allocations: 28.69 KiB)
# julia> @btime r4!($f);
#   1.230 μs (6 allocations: 384 bytes)
# julia> @btime r5!($f);
#   1.210 μs (6 allocations: 384 bytes)
# julia> @btime r6!($f);
#   1.230 μs (6 allocations: 384 bytes)
# julia> @btime r7!($f);
#   6.750 μs (6 allocations: 57.00 KiB)

function r8!(f) # add .
    copyto!(f[:, ny, 4], f[:, ny, 2])
    copyto!(f[:, ny, 8], f[:, ny, 6])
    copyto!(f[:, ny, 7], f[:, ny, 5])
end

