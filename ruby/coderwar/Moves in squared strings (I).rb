def oper(fct, s)
  fct.call(s)
end

def vert_mirror(s)
  s.split("\n").map(&:reverse).join("\n")
end

def hor_mirror(s)
  s.split("\n").reverse.join("\n")
end


s = "abcd\nefgh\nijkl\nmnop"
p oper(method(:vert_mirror), s) 
p oper(method(:vert_mirror), s)