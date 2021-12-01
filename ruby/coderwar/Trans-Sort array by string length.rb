
def sort_by_length(arr)
  arr.sort_by(&:length)
end

p "Base Tests"

tests = [
    [["i", "to", "beg", "life"], ["beg", "life", "i", "to"]],
    [["", "pizza", "brains", "moderately"], ["", "moderately", "brains", "pizza"]],
    [["short", "longer", "longest"], ["longer", "longest", "short"]],
    [["a", "of", "dog", "food"], ["dog", "food", "a", "of"]],
    [["", "bees", "eloquent", "dictionary"], ["", "dictionary", "eloquent", "bees"]],
    [["a short sentence", "a longer sentence", "the longest sentence"], ["a longer sentence", "the longest sentence", "a short sentence"]],
]

tests.each {|li| p sort_by_length(li[1])==li[0] }

p "Random Tests"
def gen_test_case
  arr = [*(1..1000)].
    shuffle[0, rand(1..100)]. # arr.length
    sort.
    map{|len| (36**(len-1) + rand(36**len - 36**(len-1))).to_s(36)}
  [arr.shuffle(random: Random.new), arr]
end

for _ in 0..50 do
  test_case = gen_test_case()
  puts sort_by_length(test_case[0])==test_case[1]
end

=begin



describe "Basic Tests"
tests = [
    [["i", "to", "beg", "life"], ["beg", "life", "i", "to"]],
    [["", "pizza", "brains", "moderately"], ["", "moderately", "brains", "pizza"]],
    [["short", "longer", "longest"], ["longer", "longest", "short"]],
    [["a", "of", "dog", "food"], ["dog", "food", "a", "of"]],
    [["", "bees", "eloquent", "dictionary"], ["", "dictionary", "eloquent", "bees"]],
    [["a short sentence", "a longer sentence", "the longest sentence"], ["a longer sentence", "the longest sentence", "a short sentence"]],
]

tests.each |li| do
  Test.assert_equals(sort_by_length(li[1]), li[0])
end

describe "Random Tests"

def gen_test_case
  prng = Random.new
  arr = [*(1...1000)].
    sample(prng.rand(5..1000)). # arr.length
    sort.
    map{|len| rand(36**len).to_s(36)}
  [arr.shuffle(random: Random.new), arr]
end

for _ in 0..100 do
  test_case = generate_test_case()
  Test.assert_equals(sort_by_length(test_case[0]), test_case[1])
end

=end

