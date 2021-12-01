def rps(p, q)
  n = {
  'rock'      => [1,0,0],   # i = j x k
  'scissors'  => [0,1,0],   # j = k x i
  'paper'     => [0,0,1]    # k = i x j 
  }
  
  p n[p], n[q]
  
  # r = dot([1,1,1], cross(p, q))
  # 即计算 pq与单位向量的混合积
  r = n[p][1]*n[q][2] - n[p][2]*n[q][1] +
      n[p][2]*n[q][0] - n[p][0]*n[q][2] +
      n[p][0]*n[q][1] - n[p][1]*n[q][0] 
      
  print n[p][1]*n[q][2] - n[p][2]*n[q][1],' ',
      n[p][2]*n[q][0] - n[p][0]*n[q][2],' ',
      n[p][0]*n[q][1] - n[p][1]*n[q][0],' ',
      r,
      "\n"
  
  # 1 => 1 ; -1 => 2 ; 0 => 1.5
  r = r* -0.5 + 1.5
  r == 1.5 ? 'Draw!' : "Player #{r.to_i} won!"
end


# --------------- test case --------------------

p '----------player 1 win----------'
p rps('rock', 'scissors')
p rps('scissors', 'paper')
p rps('paper', 'rock')

p '----------player 2 win----------'
p rps('scissors', 'rock')
p rps('paper', 'scissors')
p rps('rock', 'paper')

p '----------Draw!----------'
p rps('rock', 'rock')
p rps('scissors', 'scissors')
p rps('paper', 'paper')