function lineGC(seq::String)
    GCnumber=count(x->(x=='G'||x=='C'||x=='g'||x=='c'),seq)
    lineNum=count(x->(x!='N' && x!='n'),seq)
    (GCnumber,lineNum)
end

function calGC(fs)
    GCnumber=zero(Int)
    lineNum=zero(Int)

    for line in eachline(fs)
        if startswith(line,">")
            continue
        else
            GC,all=lineGC(line)
            GCnumber+=GC
            lineNum+=all
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

# main()