function lineGC(seq::String)
    GCnumber=count(x->(x=='G'||x=='C'||x=='g'||x=='c'),seq)
    lineNum=count(x->(x!='N' && x!='n'),seq)
    (GCnumber,lineNum)
end

function calGC(fs)
    GCnumber=zero(Int)
    lineNum=zero(Int)
    open(fs,"r") do IOstream
        for line in eachline(IOstream)
            if startswith(line,">")
                continue
            else
                GC,all=lineGC(line)
                GCnumber+=GC
                lineNum+=all
            end
        end
    end
    # round(GCnumber/lineNum;digits=3)
    GCnumber, lineNum
end

# println("GC content: ",calGC(ARGS[1]))
function main()
    path = raw"H:\hg38.fa"
    GCnumber, lineNum = calGC(path)
    println("GC=$(GCnumber); total=$(lineNum); frac=", GCnumber/lineNum)
end


# # line=64_186_394
# function countAll(fname::String)
#     GCnumber = 0
#     lineNum = 0

#     for line in eachline(fname)
#         if startswith(line, ">")
#             continue
#         else
#             GCnumber += count(x->(x=='G'||x=='C'||x=='g'||x=='c'), line)
#             lineNum += count(x->(x!='N' && x!='n'), line)
#         end
#     end
    
#     GCnumber, lineNum
# end

# function main()
#     path = raw"H:\hg38.fa"
#     GCnumber, lineNum = countAll(path)
#     @show GCnumber, lineNum
#     println("GC content: ", GCnumber/lineNum)
# end


# function ifCount(f::Function, seq::AbstractString)
#     if startswith(seq, ">")
#         0
#     else
#         count(f, seq)
#     end
# end

# countGC(seq::AbstractString) = ifCount(x->(x=='G'||x=='C'||x=='g'||x=='c'), seq)
# countGC(::Nothing) = 0

# countLine(seq::AbstractString) = ifCount(x->(x!='N' && x!='n'), seq)
# countLine(::Nothing) = 0

# function calGC1(fname::String)
#     GCnumber = zero(Int64)
#     lineNum = zero(Int64)
#     for line in eachline(fname)
#         GCnumber += countGC(line)
#         lineNum += countLine(line)
#     end
    
#     GCnumber, lineNum
# end

# path = raw"H:\hg38.fa"
# GCnumber, lineNum = calGC1(path)
# @show GCnumber, lineNum
# println("GC content: ", round(GCnumber/lineNum; digits=3))
