def x(n)
  return '' if n<3 || n.even?
  return "\u25A0" if m==1
  "\u25A0" + "\u25A1"*(n-2) + "\u25A0" +
  "\u25A1" + x(n-2) + "\u25A1" +
  "\u25A0" + "\u25A1" + "\u25A0"
  (1..n).map{|i| (1..n+1).each}
end

x(3)