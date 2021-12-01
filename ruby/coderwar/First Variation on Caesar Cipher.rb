class CaesarCipher
  attr_accessor :shift
  
  def initialize(shift=1)
    @shift = shift
  end 
  
  def encode(s,shift=@shift)
    t = s.chars.join.upcase
    t.gsub!(/[A-Z]/) do |c| 
      c.ord.+(shift%26).
      %('Z'.ord+1).
      tap{|obj| obj += 'A'.ord unless obj >= c.ord}.chr
    end
  end

  def decode(s)
    s.chars.map {|c| (c=~/[a-z]/i)!=0 ? encode(c, 26-@shift) : c}.join
  end

end


for i in 0..1
  c = CaesarCipher.new(i)
  print i,'->',c.decode('rzed'),"\n"
end





=begin

u = "1234I should have known that you would have a perfect answer for me!!!", "\n"

p c.encode('Co  de13wa rs') # returns 'HTIJBFWX'
p c.decode('B,/5FK KQJX') # returns 'WAFFLES'
=end
