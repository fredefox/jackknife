module Jackknife.Strat (jackknife) where

import Control.Parallel.Strategies

import qualified Jackknife.Sequential as Sequential (jackknife)

granularity :: Int
granularity = 50

jackknife :: NFData b => ([a] -> b) -> [a] -> [b]
jackknife f xs = (Sequential.jackknife f xs) `using` parListChunk granularity rdeepseq
