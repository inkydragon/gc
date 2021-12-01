# Guess num between [0..9]
num = rand(10)
puts "Let's guess number !\nHave a guess!\n" 
loop do
    tmp = gets.to_i
    puts "Too High" if num < tmp
    puts "Too Low" if num > tmp
    break if num == gets.to_i 
end
puts "Yes! rand number is #{num}"