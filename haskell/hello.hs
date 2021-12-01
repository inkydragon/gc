{-
fun   "+1s" = "Ha"
fun x = "I'm angry!"

factorial 0=1
factorial n = factorial(n-1)*n


panduan [a,b,c]
  | lenINF > long = "o that's too big"
  | lenINF < short = "what a pity"
  | otherwise = "eh"
  where lenINF = maximum [abs a, abs b, abs c]
        (short, long) = (5, 10)

trioArea [a,b,c] =  let p = (a+b+c)/2 in  sqrt (p*(p-a)*(p-b)*(p-c))
-}

{-calcBmis xs = [bmi | (w, h) <- xs, let bmi = w / h ^ 2, bmi >= 25.0]

mogic xs = case xs of
  "批判一番" -> "I'M ANGRY!"
  "谈笑风生" -> "美国那个华莱士呀，不知比你高到哪里去了"
  otherwise -> "我要一句话不说，那也不好"

zip' :: [a] -> [b] -> [(a,b)]
zip' _ [] = []
zip' [] _ = []
zip' (x:xs) (y:ys) = (x,y):zip' xs ys


take' 0 _ =[]
take' _ [] = []
take' n (x:xs) = (x:take'  (n-1) (xs))

take'' n a
    |n==0  =[]
    |a==[] =[]
    |otherwise= ((head a ):take''  (n-1) (tail a))
    -}
numLongChains :: Int
numLongChains = length (filter (\xs -> length xs > 15) (map chain [1..100]))
