def step(n)
  if (n-s(n)) != 0
    s=[]
    s += step(n-s(n))
  else
    s = [s(n),0]
  end
  s
end

def s(num)
  num.to_s.chars.map(&:to_i).reduce(:+)
end

p step(27)