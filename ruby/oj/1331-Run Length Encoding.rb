ARGF.each_line do |line| 
  arr = line.scan(/\w/)
  
  count = 0
  last_chr = arr[0]
  
  arr.each do |c|
    if c == last_chr
      count +=1
    else
      print count, last_chr
      #print 1 unless count !=1
      last_chr = c
      count = 1
    end
  end
  print count, last_chr, "\n"
end