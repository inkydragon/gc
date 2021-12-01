{-# LANGUAGE FlexibleContexts #-}
import Optional
import Data.Maybe

tiaosheng :: (Optional2 [Int] (Maybe Int) Int r) => r
tiaosheng = opt2 tiaosheng' [] Nothing

tiaosheng' :: [Int] -> Maybe Int -> Int
tiaosheng' a e
  | a == [] = 60 - err
  | (head a+err) >= 57 = min (head a) (60-err)
  | otherwise = tiaosheng' (tail a) (Just (err+3))
  where err = e//0

p :: Int -> IO ()
p = putStrLn . show

main = do
  p (tiaosheng [])


--(//) = flip fromMaybe
(//) :: Maybe a -> a -> a
Just x  // _ = x
Nothing // y = y

