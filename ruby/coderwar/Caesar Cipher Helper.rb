class CaesarCipher
  attr_accessor :shift
  
  def initialize(shift=1)
    @shift = shift
  end 
  
  def encode(s, shift=@shift)
    t = s.chars.join.upcase
    t.gsub!(/\w/) do |c| 
      tmp = c.ord.+(shift%26).%('Z'.ord+1)
      tmp += 'A'.ord unless tmp >= c.ord
      tmp.chr
    end
  end
  

  def decode(s)
    encode(s, -@shift)
  end
end

c = CaesarCipher.new(5)
p c.encode('Codewars') # returns 'HTIJBFWX'
p c.encode('BFKKQJX', 21) # returns 'WAFFLES'
p c.encode('HTIJBFWX', 21)
p c.decode('BFKKQJX') # returns 'WAFFLES'
p c.decode('HTIJBFWX')
