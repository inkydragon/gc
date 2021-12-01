-- hw 1

allEven :: [Integer] -> [Integer]
allEven [] = []
allEven (h:t) = if even h then h:allEven t else allEven t

allEven2 :: [Integer] -> [Integer]
allEven2 [] = []
allEven2 (h:t)
  | even h = h:allEven2 t
  | otherwise = allEven2 t

allEven3 :: [Integer] -> [Integer]
allEven3 [] = []
allEven3 (h:t)
  | odd h = allEven3 t
  | otherwise = h:allEven3 t

allEven4 :: [Integer] -> [Integer]
allEven4 l = [n | n <- l, even n]

allEven5 :: [Integer] -> [Integer]
allEven5 = undefined

--- hw 2

reverse0 = reverse

reverse1 :: [t] -> [t]
reverse1 [] = []
reverse1 (h:t) = (reverse1 t) ++ [h]

reverse2 :: [t] -> [t]
reverse2 = undefined

-- hw 3

--compose :: String s => [s] -> [(s1, s2)]
compose
