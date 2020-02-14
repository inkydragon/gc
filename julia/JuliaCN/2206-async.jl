c1 = Channel(32)
c2 = Channel(32)

function fn()
    while (data = take!(c1)) != "end" # 这里的判断是多余的
        put!(c2, length(data))
    end
end


@async fn()
while (s = readline(stdin)) != "end"
    put!(c1, s)
    len = take!(c2)
    println("You entered $(len) word" * (len==1 ? "" : "s"))
end
