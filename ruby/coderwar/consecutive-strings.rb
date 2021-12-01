def longest_consec(strarr, k)
  strarr = 
  if strarr[k] && k>0
    strarr.sort_by!(&:length).pop + longest_consec(strarr, k-1)
  else
    ""
  end
end

print longest_consec(["zone", "abigail", "theta", "form", "libe", "zas", "theta", "abigail"], 2), "\n"