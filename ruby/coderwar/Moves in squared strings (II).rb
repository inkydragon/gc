def oper(fct, s)
  fct.call(s)
end

def rot(strng)
  strng.split("\n").map(&:reverse).reverse.join("\n")
end

def selfie_and_rot(strng)
  strng.split("\n").map{|s| s+'.'*s.length}.
  +(rot(strng).split("\n").map{|s| '.'*s.length+s}).
  join("\n")
end


s = "abcd\nefgh\nijkl\nmnop"
puts oper(method(:rot), s) 
puts oper(method(:selfie_and_rot), s)

s2 = "SRxxttTQcd..........\ngmKMsvAVrk..........\nIPEHvzqWsL..........\nEThKnyCKXu..........\nZQZwwqEJOJ..........\ncuAMMNexVP..........\nQhnAbkwVou..........\nasclUAfCjZ..........\nfizNlTxFtx..........\nkWoMMrsRwh..........\n..........hwRsrMMoWk\n..........xtFxTlNzif\n..........ZjCfAUlcsa\n..........uoVwkbAnhQ\n..........PVxeNMMAuc\n..........JOJEqwwZQZ\n..........uXKCynKhTE\n..........LsWqzvHEPI\n..........krVAvsMKmg\n..........dcQTttxxRS"

puts oper(method(:rot), s2) 
puts oper(method(:selfie_and_rot), s2)