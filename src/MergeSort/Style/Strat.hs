module MergeSort.Style.Strat (mergesort) where

import Control.Parallel.Strategies

import MergeSort.Util (halve, merge)
import qualified MergeSort.Style.Sequential as Sequential

granularity :: Int
granularity = 5

mergesort' :: (NFData a, Ord a) => [a] -> [a]
mergesort' xs = mergesort xs `using` parListChunk granularity rdeepseq

-- | Sequential reference implementation
mergesort :: Ord a => [a] -> [a]
mergesort [] = []
-- The biggest possible sublist created from repeated applications of `halve`
-- has a single element in it. So we must must have two base-cases.
mergesort [x] = [x]
mergesort xs = l' `merge` r'
  where
    (l, r) = halve xs
    l' = mergesort l
    r' = mergesort r
