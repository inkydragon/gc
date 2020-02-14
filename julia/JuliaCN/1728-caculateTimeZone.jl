# caculateTimeZone.jl

"""
根据经度计算时区。
"""
function tz(lon::Real)::Int
    d = div(lon, 15) |> Int
    r = rem(lon, 15)
    if r < 7.5
        d
    else
        d + (lon>0 ? 1 : -1)
    end
end
function TimeZone(lon::Real)
    r = tz(lon)
    tl = r>=0 ? '+'*string(r) : string(r) 
    "UTC" * tl
end


for i in range(-180, step=15, stop=180)
    TimeZone(i) |> println
end
