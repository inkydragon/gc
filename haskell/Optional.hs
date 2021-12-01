{-# LANGUAGE MultiParamTypeClasses, FlexibleInstances, FlexibleContexts #-}
module Optional where

class Optional1 a b r where 
  opt1 :: (a -> b) -> a -> r

instance Optional1 a b b where
  opt1 = id

instance Optional1 a b (a -> b) where
  opt1 = const

---

class Optional2 a b c r where 
  opt2 :: (a -> b -> c) -> a -> b -> r

instance Optional2 a b c c where
  opt2 = id

instance (Optional1 b c r) => Optional2 a b c (a -> r) where
  opt2 f _ b = \a -> opt1 (f a) b

{- Optional3, Optional4, etc defined similarly -}