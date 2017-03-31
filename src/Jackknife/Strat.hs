module Jackknife.Strat (jackknife) where

import Control.DeepSeq (rnf)
import Control.Parallel (pseq)
import Control.Parallel.Strategies hiding (parList, rdeepseq)

import qualified Jackknife.Sequential as Sequential (jackknife)

granularity :: Int
granularity = 50

jackknife :: NFData b => ([a] -> b) -> [a] -> [b]
-- jackknife f xs = (Sequential.jackknife f xs) `using` parListChunk granularity rdeepseq
jackknife f xs = (Sequential.jackknife f xs) `using` parList rdeepseq

parList :: Strategy a -> Strategy [a]
parList _ [] = pure []
parList strat (x:xs) = do
  x' <- rpar (x `using` strat)
  xs' <- parList strat xs
  pure (x' : xs')

rdeepseq :: NFData a => Strategy a
rdeepseq x = rnf x `pseq` pure x
