def oper(fct, s)
  fct.call(s)
end

def diag_1_sym(strng)
  strng.split("\n").map(&:reverse).reverse.join("\n")
end

def rot_90_clock(strng)
  
end

def selfie_and_rot(strng)
  strng.split("\n").map{|s| s+'.'*s.length}.
  +(rot(strng).split("\n").map{|s| '.'*s.length+s}).
  join("\n")
end


s = "abcd\nefgh\nijkl\nmnop"
puts oper(method(:rot), s) 
puts oper(method(:selfie_and_rot), s)