using ShiftedArrays

# const nx = 1200
# const ny = 600
# const Q = 9
# f = rand(Int, nx, ny, Q);
# const cx = [1 0 -1  0 1 -1 -1  1 0]; #velocity components in horizontal direction
# const cy = [0 1  0 -1 1  1 -1 -1 0]; #velocity components in vertical direction

function streaming0!(Q, cx, cy, f)
for k = 1:Q
    @views f[:, :, k] .= circshift(f[:, :, k], (cx[k], cy[k]))
end
end

function streaming1!(Q, cx, cy, f)  # no dot
for k = 1:Q
    @views f[:, :, k] = circshift(f[:, :, k], (cx[k], cy[k]))
end
end

function streaming2!(Q, cx, cy, f)
for k = 1:Q
    @views f[:, :, k] .= ShiftedArrays.circshift(f[:, :, k], (cx[k], cy[k]))
end
end

function streaming3!(Q, cx, cy, f)
for k = 1:Q
    @views f[:, :, k] = ShiftedArrays.circshift(f[:, :, k], (cx[k], cy[k]))
end
end
