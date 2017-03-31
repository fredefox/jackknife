module MergeSort.Style.Explicit (mergesort) where

import Control.Parallel

import MergeSort.Util (halve, merge)
import qualified MergeSort.Style.Sequential as Sequential

granularity :: Int
granularity = 5

mergesort :: Ord a => [a] -> [a]
mergesort = granularMergesort granularity

-- | Explicit parallel implementation with granularity control.
granularMergesort :: Ord a => Int -> [a] -> [a]
granularMergesort n
  | n <= 0    = Sequential.mergesort
  | otherwise = parMergesort
    where
      step :: Ord a => [a] -> [a]
      step = granularMergesort (n - 1)
      parMergesort :: Ord a => [a] -> [a]
      parMergesort [] = []
      parMergesort [x] = [x]
      parMergesort xs = l' `par` r' `pseq` (l' `merge` r')
        where
          (l, r) = halve xs
          l' = step l
          r' = step r
