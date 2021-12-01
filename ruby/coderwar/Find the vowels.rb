def _vowel(word, num=0)
  if i = word =~ /[aeiouy]/i
	  num +=  i+1
    [num] + _vowel($', num)
  else
    []
  end
end



print vowel_indices("Mmmm"), "\n"
print vowel_indices("Super"), "\n"
print vowel_indices("Apple"), "\n"
print vowel_indices("YoMama"), "\n"