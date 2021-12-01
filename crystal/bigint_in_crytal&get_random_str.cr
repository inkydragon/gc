require "big"  # require libgmp-dev
def gen_test_case
  arr = (2..200).reduce([1]){|sum, i| sum + [i]}.
    shuffle[1, rand(10..50)]. # arr.length
    sort.
    map{|len| (36**(len-1) + rand(36**len - 36**(len-1))).to_s(36)}
  [arr.shuffle, arr]
end

(2..200).reduce([1]){|sum, i| sum + [i]}.
    shuffle[1, rand(10..15)].
		sort.each do |len|
	len = len.to_big_f
	len**2
  36**(len - 1)
  36**len - 36**(len - 1)
  rand(36**len - 36**(len - 1)).to_big_i.to_s(36)
end