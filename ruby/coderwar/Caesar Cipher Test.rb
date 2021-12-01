
def encode(s,shift=@shift)
  t = s.chars.join.upcase
  t.gsub!(/[A-Z]/) do |c| 
    c.ord.+(shift%26).
    %('Z'.ord+1).
    tap{|obj| obj += 'A'.ord unless obj >= c.ord}.chr
  end
end

def movingShift(s, shift)
  t = s.chars.join    # deep clone 保证输入字符串s不变
  t.gsub!(/\w/) do |c| 
    isUC = c.ord < 91
    tmp = c.ord.+(shift%26).%((isUC ? 'Z' : 'z').ord+1)
    tmp += (isUC ? 'A' : 'a').ord unless tmp >= c.ord
    tmp.chr
  end
end

for i in 0..26
  print i,'->',movingShift('abcdef',26-i),"\n"
  print '  ','->',movingShift('aarzed',26-i),"\n"
  print '  ','->',movingShift('xyztas',26-i),"\n"
  #print '  ','->',movingShift('rzed',26-i),"\n"
end