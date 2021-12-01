{-# LANGUAGE NoImplicitPrelude #-}
module Monads where

import Prelude hiding (return,
                       (>>=),
                       Monad,
                       Identity,
                       Maybe(..),
                       State,
                       Reader,
                       Writer
import Data.Monoid

class Monad m where
  return :: a -> m a
  (>>=) :: m a -> (a -> m b) -> m b

data Identity a = Identity a
  deriving (Show, Eq)

data Maybe a = Nothing | Just a
  deriving (Show, Eq)

data State s a = State {runState :: s -> (a, s)}

data Reader s a = Reader {runReader :: s -> a }

data Writer w a = Writer {runWriter :: (a, w)}
  deriving (Show)

instance Monad Identity where
  return = Identity
  (Identity v) >>= f = f v

instance Monad Maybe where
  return = Just
  Nothing  >>= _ = Nothing
  (Just v) >>= f = f v
  -- fail _ = Nothing

instance Monad (State s) where
  return = undefined
  (State g) >>= f = undefined

instance Monad (Reader s) where
  return = undefined
  (Reader g) >>= f = undefined

instance Monoid w => Monad (Writer w) where
  return s = Writer (s, mempty)
  (Writer (s, v)) >>= f = let (Writer (r, v')) = f s
                          in Writer (r, mappend v v')
