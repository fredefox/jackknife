module Jackknife.Eval (jackknife) where

import Control.Parallel.Strategies hiding (parMap)

import Jackknife (resamples)

jackknife :: ([a] -> b) -> [a] -> [b]
jackknife f = parMap f . resamples 500

parMap :: (a -> b) -> [a] -> [b]
parMap = undefined
