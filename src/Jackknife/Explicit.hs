module Jackknife.Explicit (jackknife) where

import Control.Parallel

import Jackknife (resamples)

jackknife :: ([a] -> b) -> [a] -> [b]
jackknife f = parMap f . resamples 500

parMap :: (a -> b) -> [a] -> [b]
parMap _ []       = []
parMap f (x : xs) = fx `par` fx : parMap f xs
  where
    fx = f x
