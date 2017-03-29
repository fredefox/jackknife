module MergeSort.Style.Sequential (mergesort) where

import MergeSort.Util

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
