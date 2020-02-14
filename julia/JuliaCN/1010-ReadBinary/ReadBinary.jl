
open("ReadBinary.txt", "r+") do io
    write(io, "Hello, world!"); seek(io, 0)
    
    println(read(io, String)); seek(io, 0)
    println(read(io, 4)); seek(io, 0)
    println(read(io)); seek(io, 0)
    println(read(io, UInt8)); seek(io, 0); 
    println(read(io, UInt8)); seek(io, 0); 
end

