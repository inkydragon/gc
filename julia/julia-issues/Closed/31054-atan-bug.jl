# atan' bug

# tan(atan(z::Complex)) == z
# 
# import Base: angle
global my_debug = false

atan(z::Complex) = im/2.0 * ( log(im+z) - log(im-z) )
atan(z::Float64) = convert(Float64, atan(Complex(z, 0)))

# angle(z::Complex) = atan(imag(z), real(z))

function atanh(z::Complex{T}) where T<:AbstractFloat
    Ω = prevfloat(typemax(T))
    θ = sqrt(Ω)/4
    ρ = 1/θ
    # @show Ω θ ρ
    x, y = reim(z)
    # @assert isreal(x); @assert isreal(y)

    ax = abs(x)
    ay = abs(y)
    # @assert ax >= 0; @assert ay >= 0
    # return ξ + η*im
    if x > θ || ay > θ #Prevent overflow
        if isnan(y)
            if isinf(x)
                # return Complex(copysign(zero(x),x), y)
                ξ = copysign(zero(x),x)
                η = y
            else
                # return Complex(real(1/z), y)
                ξ = real(1/z)
                η = y
            end
        elseif isinf(y)
            # return Complex(copysign(zero(x),x), copysign(oftype(y,pi)/2, y))
            ξ = copysign(zero(x), x)
            η = copysign(oftype(y,pi)/2, y)
        else
            # return Complex(real(1/z), copysign(oftype(y,pi)/2, y))
            ξ = real(1/z)
            η = copysign(oftype(y,pi)/2, y)
        end
    elseif x == 1
        if y == 0
            ξ = copysign(oftype(x,Inf),x)
            η = zero(y)
        else
            # @show ax y
            ym = ay+ρ
            # @show ym
            ξ = log(sqrt(sqrt(4+y*y))/sqrt(ym))
            η = copysign(oftype(y,pi)/2 + atan(ym/2), y)/2
        end
    else #Normal case
        ysq = (ay+ρ)^2
        if x == 0
            ξ = x
        else
            ξ = log1p(4x/((1-x)^2 + ysq))/4
        end
        η = angle(Complex((1-x)*(1+x)-ysq, 2y))/2
    end
    Complex(ξ, η)
end
# atanh(z::T) where T<:AbstractFloat = atanh(Complex(z))
# function atanh(z::Complex{T}) where T<:AbstractFloat
#     Ω = prevfloat(typemax(T))
#     θ = sqrt(Ω)/4
#     ρ = 1/θ
#     # @show Ω θ ρ
#     x, y = reim(z)
#     β = copysign(1, x)
#     @assert isreal(x); @assert isreal(y)
# 
#     ax = abs(x)
#     ay = abs(y)
#     # @assert ax >= 0; @assert ay >= 0
#     # return ξ + η*im
#     ym = ay + ρ
#     if x > θ || ay > θ # Prevent overflow
#         # println("#> x > θ || ay > θ")
#         ξ = real(1/z)
#         η = copysign(oftype(y,pi)/2, y)
#     elseif x == 1
#         # println("#> x == 1")
#         ξ = log(sqrt(sqrt(4+y*y))/sqrt(ym))
#         η = copysign(oftype(y,pi)/2 + atan(ym/2), y)/2
#     else # Normal case
#         # println("#> Normal case")
#         ysq = (ym)^2
#         ξ = log1p(4x/((1-x)^2 + ysq))/4
#         tmp = Complex((1-x)*(1+x)-ysq, 2y)
#         η = angle(tmp)/2
#         # @show ξ tmp η
#     end
#     res = β * Complex(ξ, -1*η)
#     # @show Complex(ξ, η) β res
#     # println("# atanh' END ==== #")
#     return Complex(ξ, η)
# end
atanh9(z::Complex) = log(sqrt((1+z)/(1-z)))

function test_atanh()
    float_data_list = [-1.0, 0.0, 1.0]
    op_list = [identity, nextfloat, prevfloat]
    
    for op in op_list
    for real in float_data_list
    for imag in float_data_list
        z = op(real) + op(imag)*im
        @show z
        try 
            if tanh(atanh(z)) == z
                nothing
            elseif tanh(atanh(z)) ≈ z
                nothing
            else
                @show tanh(atanh(z)) atanh(z)
            end
        catch ex
            @show ex
        end
    end 
    end 
    end
    
end


# ========================================================

# function tanh9(z::Complex)
#     cosim = cos(z.im)
#     u = exp(z.re)
#     v = 1/u
#     u = (u+v)*0.5
#     v = u-v
#     d = cosim*cosim + v*v
#     Complex(u*v/d, sin(z.im)*cosim/d)
# end
# 
# atanh9(z::Complex) = log(sqrt((1+z)/(1-z)))
# 
# function atanh_60d266(z::Complex{T}) where T<:AbstractFloat
#     Ω=prevfloat(typemax(T))
#     θ=sqrt(Ω)/4
#     ρ=1/θ
#     x=real(z)
#     y=imag(z)
#     if x > θ || abs(y) > θ #Prevent overflow
#         return complex(copysign(pi/2, y), real(1/z))
#     elseif x==one(x)
#         ym=abs(y)+ρ
#         ξ=log(sqrt(sqrt(4+y^2))/sqrt(ym))
#         η=copysign(pi/2+atan(ym/2), y)/2
#     else #Normal case
#         ysq=(abs(y)+ρ)^2
#         ξ=log1p(4x/((1-x)^2 + ysq))/4
#         η=angle(complex(((1-x)*(1+x)-ysq)/2, y))
#     end
#     complex(ξ, η)
# end
# 
# 
# function atanh_ae6d75(z::Complex{T}) where T<:AbstractFloat
#     Ω = prevfloat(typemax(T))
#     θ = sqrt(Ω)/4
#     ρ = 1/θ
#     x, y = reim(z)
#     ax = abs(x)
#     ay = abs(y)
#     if ax > θ || ay > θ #Prevent overflow
#         if isnan(y)
#             if isinf(x)
#                 return complex(copysign(zero(x),x), y)
#             else
#                 return complex(real(1/z), y)
#             end
#         end
#         if isinf(y)
#             return complex(copysign(zero(x),x), copysign(pi/2, y))
#         end
#         return complex(real(1/z), copysign(pi/2, y))
#     elseif ax==1
#         if y == 0
#             ξ = copysign(oftype(x,Inf),x)
#             η = zero(y)
#         else
#             ym = ay+ρ
#             ξ = log(sqrt(sqrt(4+y*y))/sqrt(ym))
#             η = copysign(pi/2+atan(ym/2), y)/2
#         end
#     else #Normal case
#         ysq = (ay+ρ)^2
#         if x == 0
#             ξ = x
#         else
#             ξ = log1p(4x/((1-x)^2 + ysq))/4
#         end
#         η = angle(complex((1-x)*(1+x)-ysq, 2y))/2
#     end
#     complex(ξ, η)
# end
# atanh_ae6d75(z::Complex) = atanh(float(z))
# 
