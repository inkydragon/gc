def dig_pow(n, p)
  sum = n.to_s.chars.reduce(0){|s,d| s+d.to_i**((p+=1)-1)}
  sum%n > 0 ? -1 : sum/n 
end

puts dig_pow(89, 1), dig_pow(92, 1), dig_pow(695, 2), dig_pow(46288, 3)
