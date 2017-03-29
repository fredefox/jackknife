module Jackknife.Eval (jackknife) where

import Control.Parallel.Strategies hiding (parListChunk, parMap)

import qualified Jackknife.Sequential as Sequential (jackknife)

granularity :: Int
granularity = 50

jackknife :: NFData b => ([a] -> b) -> [a] -> [b]
jackknife f xs = (Sequential.jackknife f xs) `using` parListChunk granularity rdeepseq

-- | (Re-)implementation of `Control.Parallel.Strategies.parListChunk`
parListChunk :: Int -> Strategy a -> Strategy [a]
parListChunk _    _     []       = return []
parListChunk size strat (x : xs) = do
  fx <- rpar (x `using` strat)
  fxs <- parListChunk size strat xs
  rseq (fx : fxs)
