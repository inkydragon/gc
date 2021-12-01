def Roman_Num_Decoder(s)
  token = /[MDLV]|C[MD]?|X[CL]?|I[XV]?/
	key = { M:1000,
          CM:900, D:500, CD:400, C:100,
          XC:90,  L:50,  XL:40,  X:10,
          IX:9,   V:5,   IV:4,   I:1}
  
  s.
    upcase.
    scan(token).
    reduce(0) {|sum, rn| sum+=key[rn.to_sym]}
end

s = 'CI XCVII CXV CXXI XCIX CXVI CII CXXIII CXVI CIV CV CXV XCV CV CXV XCV CX CXI CXVI XCV CXVI CIV CI XCV CII CVIII XCVII CIII CXXV XXXII CV XXXII CVII CX CXI CXIX XXXII CXVI CIV CV CXV XXXII CII CVIII XCVII CIII XXXII CV CXV XXXII CXIX CI CV CXIV C XXXII CV XXXII CVI CXVII CXV CXVI XXXII XCIX XCVII CX XXXIX CXVI XXXII CXII CXVII CXVI XXXII CIX CXXI XXXII CII CV CX CIII CI CXIV XXXII CXI CX XXXII CXIX CIV CXXI'

s.split(' ').each do |rn|
  print Roman_Num_Decoder(rn), ', '
end
print "\n"

print Roman_Num_Decoder("MMVIII"), "\n"
print Roman_Num_Decoder("MDCLXVI"), "\n"