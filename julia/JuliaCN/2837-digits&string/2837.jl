function f(num::Int)
    @assert num∈10:99 "num=$num ∉[10, 99]"
    i = num ÷ 10
    j = num % 10
    _num = string(num)
    while j <10
        num = _num
        i, j, _num = num3(i, j, num)
    end
    num
end

function num3(i::Int, j::Int, num::String)
    @assert i∈0:9 "i=$i ∉[1, 9]"
    @assert j∈0:9 "j=$j ∉[0, 9]"
    j, i+j, "$num$(i+j)"
end

function main()
    arr = [f(i) for i in 10:99]
    sort(arr)[1]
    # arr == sort(arr)
    # f(10)
end

# main()
# "10112358"
# 44.000 μs (1229 allocations: 59.45 KiB)

#=
    穷举法 2
=#
function test_use_digits()
	max_num = 0
	for num in 100:99_999_999
		digit = digits(num)
		len = length(digit)
	    for i in len:-1:3
			if digit[i-2] != digit[i-1] + digit[i]
				break
			else
				i==3 && num > max_num ? max_num = num : nothing
			end
		end
	end
	println(max_num)
end

function test_use_string()
	max_num = 0
	for num in 100:99_999_999
		str = string(num)
		len = length(str)
	    for i in 3:len
			if parse(Int,str[i]) != parse(Int,str[i-1]) + parse(Int,str[i-2])
				break
			else
				i == len && num > max_num ? max_num = num : nothing
			end
	    end
	end
	println(max_num)
end

test_use_digits()
test_use_string()
