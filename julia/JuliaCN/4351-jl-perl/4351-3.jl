
function countAll!(arr::Vector{Int64}, seq::AbstractString)
    for c in seq
        arr[Int(c)] += 1
    end
end

function countChar(fname)
    arr = zeros(Int64, 128)

    for line in eachline(fname)
        if startswith(line,">")
            continue
        else
            countAll!(arr, line)
        end
    end

    arr
end

function main()
    path = raw"H:\hg38.fa"
    arr = countChar(path)
    G = arr[Int('G')] + arr['g' |> Int]
    C = arr['C'|> Int] + arr['c'|> Int]
    total = G+C + arr['A'|> Int] + arr['a'|> Int] +arr['T'|> Int] + arr['t'|> Int]
    println("GC=$(G+C); total=$(total); frac=", (G+C)/total)
end

main()