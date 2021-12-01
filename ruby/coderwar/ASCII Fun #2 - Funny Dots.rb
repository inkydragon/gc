def dot(n, m)
  return '' if m<1
  '+' + '---+'*n + "\n" +
  '|' + ' o |'*n + "\n" +
  dot(n, m-1) +
  (m==1 ? '+' + '---+'*n : '')
end

puts dot(1,1), dot(1,2), dot(2,1), dot(2,2)

p dot(3,2)