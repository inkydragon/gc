module Haskell.Codewars.LookAndSayAndSum where
import Control.Monad (liftM2)
import Data.List (group)
import Data.Char (digitToInt)
import System.Random (randomRIO, randomRs, getStdGen)


-- this function is composed out of many functions; data flows from the bottom up
lookAndSay :: Integer -> Integer
lookAndSay = read                                   -- convert digits to integer
           . concatMap                              -- concatenate for each run,
               (liftM2 (++) (show . length)         --    the length of it
                            (take 1))               --    and an example member
           . group                                  -- collect runs of the same digit
           . show                                   -- convert integer to digits
 
-- less comments
lookAndSay2 :: Integer -> Integer
lookAndSay2 = read . concatMap (liftM2 (++) (show . length)
                                            (take 1))
            . group . show
 
 
-- same thing with more variable names
lookAndSay3 :: Integer -> Integer
lookAndSay3 n = read (concatMap describe (group (show n)))
  where describe run = show (length run) ++ take 1 run

main' = mapM_ print (iterate lookAndSay 1)           -- display sequence until interrupted

toDigits :: Integer -> [Int]
toDigits = map (fromIntegral . digitToInt) . show

lookAndSaySum :: Int -> Int
lookAndSaySum n = foldr (+) 0 (toDigits (iterate lookAndSay3 1 !! (n-1)) )

sol :: Int -> Int
sol n = [0,1,2,3,5,8,10,13,16,23,32,44,56,76,102,132,174,227,296,383,505,679,892,1151,1516,1988,2602,3400,4410,5759,7519,9809,12810,16710,21758,28356,36955,48189,62805,81803,106647,139088,181301,236453,308150,401689,523719,682571,889807,1159977,1511915,1970964,2569494,3349648,4366359,5691884] !! n

randint :: IO Int
randint = randomRIO (1,55)

randomList :: (Random a, Num a) => IO [a]
randomList = getStdGen >>= return . randomRs (1,55)



