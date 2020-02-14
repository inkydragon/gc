# clip2array.jl

# ref: https://discourse.julialang.org/t/debug-lines/192/3
const global my_debug = false
macro dbg(str)
    :( my_debug && println($(esc(str))) )
end

function getArrayFromClipBoard()
    clip = clipboard() 
    @dbg("Raw input string: $(repr(clip))")
    
    # compute rows and columns
    row_length  = length(collect(eachmatch(r"\r\n", clip)))
    t_count     = length(collect(eachmatch(r"\t", clip)))
    col_length  = fld(t_count, row_length) + 1
    @dbg("Table has $(row_length) lines and $(col_length) columns.")
    
    str = replace(clip, "\r\n" => "\n") # merge `\r\n` to `\n`
    str = chomp(str) # chomp remove last `\n`
    @dbg("Aftre chomp: $(repr(str))")
    
    # Only One column
    if !occursin('\t', str)
        res = split(str, '\n')
        return convert(Array{String,1}, res)
    end
    
    # # Method-1: split by row first and then by column.
    # rows = split(str, '\n')
    # @dbg("Rows: $(repr(rows))")
    # res = []
    # for row in rows
    #     cols = split(row, '\t')
    #     @dbg("Add Col: $(cols)")
    #     res = vcat(res, cols)
    #     @dbg("Res: $(res)")
    # end
    
    # Method-2: just split the string and reshap it.
    str = replace(str, '\n' => ',')
    str = replace(str, '\t' => ',')
    res = split(str, ',')
    
    res = permutedims(reshape(res, col_length, row_length))
    return convert(Array{String,2}, res)
end

# Test fucntion
using Test

@testset "All tests" begin
    origin_clip = clipboard()
    
    answer = Dict(
        # Only One column
        "1\r\n2\r\n3\r\n4\r\n5\r\n6\r\n7\r\n" => ["1"; "2"; "3"; "4"; "5"; "6"; "7"],
        "1\r\n2\r\n\r\n\r\n\r\n6\r\n" => ["1", "2", "", "", "", "6"],    
        
        # Only One row
        "1\t7\t13\t19\r\n" => ["1" "7" "13" "19"],
        "1\t\t\t19\r\n" => ["1" "" "" "19"],
        
        # MxN Table
        "1\t7\t13\r\n2\t8\t14\r\n3\t9\t15\r\n4\t10\t16\r\n5\t11\t17\r\n6\t12\t18\r\n7\t13\t19\r\n8\t14\t20\r\n9\t15\t21\r\n" => ["1" "7" "13"; "2" "8" "14"; "3" "9" "15"; "4" "10" "16"; "5" "11" "17"; "6" "12" "18"; "7" "13" "19"; "8" "14" "20"; "9" "15" "21"],
        "1\t\t\t19\r\n2\t8\t14\t20\r\n\t9\t15\t21\r\n\t10\t16\t22\r\n\t11\t17\t23\r\n6\t12\t18\t24\r\n" => ["1" "" "" "19"; "2" "8" "14" "20"; "" "9" "15" "21"; "" "10" "16" "22"; "" "11" "17" "23"; "6" "12" "18" "24"],
        
    )
    
    for clip in collect(keys(answer))
        println("\nTesting Table: ")
        show(stdout, "text/plain", answer[clip])
        println()
        
        clipboard(clip)
        @test getArrayFromClipBoard() == answer[clip]
    end

    clipboard(origin_clip)
end
