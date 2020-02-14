# saving RGB/RGBA image into uncompressed PNG.
# https://github.com/miloyip/svpng

#=
    辅助函数
=#
SVPNG_PUT(io::IO, b::UInt8) = write(io, b)
SVPNG_PUT(io::IO, b::UInt32) = SVPNG_PUT(io, UInt8(b))

#= 
void SVPNG_U8A(ua, l) {
    for (i = 0; i < l; i++) 
        SVPNG_PUT((ua)[i]); 
}
=#
SVPNG_U8A(io::IO, ua::Base.CodeUnits{UInt8,String}) = 
    for b in ua
        SVPNG_PUT(io, b)
    end

#= 
void SVPNG_U32(u) { 
    SVPNG_PUT((u) >> 24); 
    SVPNG_PUT(((u) >> 16) & 255); 
    SVPNG_PUT(((u) >> 8) & 255); 
    SVPNG_PUT((u) & 255); 
}
=#
function SVPNG_U32(io::IO, u::UInt32)
    SVPNG_PUT(io,  u >> 24)
    SVPNG_PUT(io, (u >> 16) & 0xFF)
    SVPNG_PUT(io, (u >> 8 ) & 0xFF)
    SVPNG_PUT(io,  u & 0xFF)
end

#=
void SVPNG_U8C(u) { 
    SVPNG_PUT(u); 
    c ^= (u); 
    c = (c >> 4) ^ t[c & 15]; 
    c = (c >> 4) ^ t[c & 15]; 
}
=#
function SVPNG_U8C(
        io::IO,
        u::UInt8,
        crc::UInt32,
        t::Array{UInt32,1}
    ) ::UInt32
    SVPNG_PUT(io, u)
    c = crc
    c = c ⊻ (u)
    c = (c >> 4) ⊻ t[c & 0x0F+1]
    c = (c >> 4) ⊻ t[c & 0x0F+1]
    c
end
SVPNG_U8C(
    io::IO, 
    u::Union{T, Bool} where {T<:Integer}, 
    c::UInt32, 
    t::Array{UInt32,1}
) ::UInt32 = SVPNG_U8C(io, UInt8(u), c, t)

#=
void SVPNG_U8AC(ua, l) {
    for (i = 0; i < l; i++) 
        SVPNG_U8C((ua)[i])
}
=#
function SVPNG_U8AC(
        io::IO, 
        ua::Base.CodeUnits{UInt8,String}, 
        crc::UInt32, 
        t::Array{UInt32,1}
    )
    c = crc
    for b in ua
        c = SVPNG_U8C(io, b, c, t)
    end
    c
end

#=
void SVPNG_U16LC(u) { 
    SVPNG_U8C( (u) & 255 ); 
    SVPNG_U8C( ((u) >> 8) & 255 ); 
}
=#
function SVPNG_U16LC(
        io::IO, 
        u::UInt32, 
        crc::UInt32, 
        t::Array{UInt32,1}
    )
    c = crc
    c = SVPNG_U8C(io, u & 0xFF, c, t)
    c = SVPNG_U8C(io, (u >> 8) & 0xFF, c, t)
    c
end
# SVPNG_U16LC(io::IO, u::UInt32, c, t) = 
#     SVPNG_U16LC(io, UInt16(u), c, t)

#=
void SVPNG_U32C(u) { 
    SVPNG_U8C(  (u) >> 24 ); 
    SVPNG_U8C( ((u) >> 16) & 255 ); 
    SVPNG_U8C( ((u) >> 8) & 255 ); 
    SVPNG_U8C(  (u) & 255 ); 
}
=#
function SVPNG_U32C(
        io::IO, 
        u::UInt32, 
        crc::UInt32, 
        t::Array{UInt32,1}
    )
    c = crc
    c = SVPNG_U8C(io,  u >> 24, c, t)
    c = SVPNG_U8C(io, (u >> 16) & 0xFF, c, t)
    c = SVPNG_U8C(io, (u >> 8 ) & 0xFF, c, t)
    c = SVPNG_U8C(io,  u & 0xFF, c, t)
    c
end

#=
void SVPNG_U8ADLER(u) { 
    SVPNG_U8C(u); 
    a = (a + (u)) % 65521; 
    b = (b +  a)  % 65521; 
}
=#
function SVPNG_U8ADLER(
        io::IO, 
        u::UInt8, 
        a::UInt32, 
        b::UInt32, 
        crc::UInt32, 
        t::Array{UInt32,1}
    )
    c = crc
    c = SVPNG_U8C(io, u, c, t)
    a = (a + u) % 0xFFF1
    b = (b + a) % 0xFFF1
    a, b, c
end
SVPNG_U8ADLER(
    io::IO, 
    u::T, 
    a::UInt32, 
    b::UInt32, 
    c::UInt32, 
    t::Array{UInt32,1}
) where {T<:Integer} = 
    SVPNG_U8ADLER(io, UInt8(u), a, b, c, t)

#=
void SVPNG_BEGIN(s, l) { 
    SVPNG_U32(l); 
    c = ~0U; 
    SVPNG_U8AC(s, 4); 
}
=#
function SVPNG_BEGIN(
        io::IO, 
        s::Base.CodeUnits{UInt8,String}, 
        l::UInt32,
        t::Array{UInt32,1}
    )
    SVPNG_U32(io, l)
    c = ~zero(UInt32)
    c = SVPNG_U8AC(io, s, c, t)
    c
end
SVPNG_BEGIN(
    io::IO, 
    s::Base.CodeUnits{UInt8,String}, 
    l::T,
    t::Array{UInt32,1}
) where {T <: Integer} = SVPNG_BEGIN(io, s, UInt32(l), t)

#= void SVPNG_END() SVPNG_U32(~c); =#
SVPNG_END(io::IO, c::UInt32) = SVPNG_U32(io, ~c)

#=
void svpng(
        SVPNG_OUTPUT, 
        unsigned w, 
        unsigned h, 
        const unsigned char* img, 
        int alpha
    ) {
    SVPNG_U8A("\x89PNG\r\n\32\n", 8);           /* Magic */
    SVPNG_BEGIN("IHDR", 13);                    /* IHDR chunk { */
    SVPNG_U32C(w); SVPNG_U32C(h);               /*   Width & Height (8 bytes) */
    SVPNG_U8C(8); SVPNG_U8C(alpha ? 6 : 2);     /*   Depth=8, Color=True color with/without alpha (2 bytes) */
    SVPNG_U8AC("\0\0\0", 3);                    /*   Compression=Deflate, Filter=No, Interlace=No (3 bytes) */
    SVPNG_END();                                /* } */
    SVPNG_BEGIN("IDAT", 2 + h * (5 + p) + 4);   /* IDAT chunk { */
    SVPNG_U8AC("\x78\1", 2);                    /*   Deflate block begin (2 bytes) */
    for (y = 0; y < h; y++) {                   /*   Each horizontal line makes a block for simplicity */
        SVPNG_U8C(y == h - 1);                  /*   1 for the last block, 0 for others (1 byte) */
        SVPNG_U16LC(p); SVPNG_U16LC(~p);        /*   Size of block in little endian and its 1's complement (4 bytes) */
        SVPNG_U8ADLER(0);                       /*   No filter prefix (1 byte) */
        for (x = 0; x < p - 1; x++, img++)
            SVPNG_U8ADLER(*img);                /*   Image pixel data */
    }
    SVPNG_U32C((b << 16) | a);                  /*   Deflate block end with adler (4 bytes) */
    SVPNG_END();                                /* } */
    SVPNG_BEGIN("IEND", 0); SVPNG_END();        /* IEND chunk {} */
}
=#
function svpng(io::IO, w::UInt32, h::UInt32, img, alpha::Bool)
    # @info "" w h alpha
    # const t = [
    t = [
        0x00000000, 0x1db71064, 0x3b6e20c8, 0x26d930ac, 
        0x76dc4190, 0x6b6b51f4, 0x4db26158, 0x5005713c, 
        0xedb88320, 0xf00f9344, 0xd6d6a3e8, 0xcb61b38c, 
        0x9b64c2b0, 0x86d3d2d4, 0xa00ae278, 0xbdbdf21c 
    ] # CRC32 Table
    
    #=
    unsigned a = 1, b = 0, c, p = w * (alpha ? 4 : 3) + 1, x, y, i;   
    ADLER-a, ADLER-b, CRC, pitch
    =#
    a = UInt32(1)   # ADLER-a
    b = UInt32(0)   # ADLER-b
    # c = ~UInt32(0) # CRC
    p = UInt32(w * (alpha ? 4 : 3) + 1) # pitch
    # @info "" a b p
    
    #= 1-Magic Number =#
    SVPNG_U8A(io, b"\x89PNG\r\n\32\n")  # Magic
    
    #= 2-IHDR chunk Begin =#
    c = SVPNG_BEGIN(io, b"IHDR", 13, t) # IHDR chunk { (total 13 bytes)
    c = SVPNG_U32C(io, w, c, t)         #   Width  (4 bytes)
    c = SVPNG_U32C(io, h, c, t)         #   Height (4 bytes)
    c = SVPNG_U8C(io, 8, c, t)          #   Depth = 8 (1 bytes)
    color = alpha ? 6 : 2 
    c = SVPNG_U8C(io, color, c, t)      #   Color = with/without alpha 
                                        #     (1 bytes)
    c = SVPNG_U8AC(io, b"\0\0\0", c, t) #   Compression = 
                                        #     Deflate, 
                                        #     Filter=No, 
                                        #     Interlace=No 
                                        #     (3 bytes)
    SVPNG_END(io, c);                   # }
    #= IHDR chunk End =# 
    
    #= 3-IDAT chunk Begin =#
    IDAT_len = 2 + h*(5+p) + 4 # TODO: Maybe there is 2+ h*(6+p) +4
    c = SVPNG_BEGIN(io, b"IDAT", IDAT_len, t) # IDAT chunk {
    c = SVPNG_U8AC(io, b"\x78\1", c, t)         #   Deflate block begin 
                                                #     (2 bytes)
    for y in 1:h 
        #   Each horizontal line makes a block for simplicity
        c = SVPNG_U8C(io, y == h, c, t);       
        #   1 for the last block, 0 for others (1 byte) 
        c = SVPNG_U16LC(io, p, c, t); 
        c = SVPNG_U16LC(io, ~p, c, t);        
        #   Size of block in little endian and its 1's complement 
        #     (4 bytes) 
        a, b, c = SVPNG_U8ADLER(io, 0, a, b, c, t);                       #   No filter prefix (1 byte)
        for pix in view(img, ( (y-1)*(p-1)+1 ):( y*(p-1) ) )
            a, b, c = SVPNG_U8ADLER(io, pix, a, b, c, t)    
            #   Image pixel data
        end
    end
    c = SVPNG_U32C(io, (b << 16) | a, c, t);                  
    #   Deflate block end with adler (4 bytes) 
    SVPNG_END(io, c);                        
    # } 
    #= IDAT chunk End =# 
    
    #= 4-IEND chunk =#
    c = SVPNG_BEGIN(io, b"IEND", 0, t); SVPNG_END(io, c) # IEND chunk {}
end # svpng function end
svpng(io::IO, w::T, h::T, img) where {T<:Integer} = 
    svpng(io, w, h, img, false)
svpng(io::IO, w::T, h::T, img, alpha::Bool) where {T<:Integer} =
    svpng(io, UInt32(w), UInt32(h), img, alpha)


#=
    使用 svpng()
=#
open("svPNG-1.png", "w") do io
    # write(io, "\x89PNG\r\n\32\n")
    img = Array{UInt8,1}()
    w = 256
    h = 256
    alpha = false
    
    for y in 0:(w-1)
        for x in 0:(h-1)
            append!(img, UInt8(x))   # R
            append!(img, UInt8(y))   # G
            append!(img, UInt8(128)) # B
        end
    end
    svpng(io, w, h, img, alpha)
end;
