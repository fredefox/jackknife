module MergeSort.Style.Explicit (mergesort, merge, halve) where

import Control.DeepSeq (NFData, rnf)
import Control.Parallel

import MergeSort.Util

-- TODO: Implement granularity control
-- | Explicit parallel implementation
mergesort :: (NFData a, Ord a) => [a] -> [a]
mergesort [] = []
mergesort [x] = [x]
mergesort xs = rnf l' `par` rnf r' `pseq` (l' `merge` r')
  where
    (l, r) = halve xs
    l' = mergesort l
    r' = mergesort r
