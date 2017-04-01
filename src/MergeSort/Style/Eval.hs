module MergeSort.Style.Eval (mergesort) where

import Control.Parallel.Strategies

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
  | otherwise = runEval . parMergesort
    where
      step :: Ord a => [a] -> [a]
      step = granularMergesort (n - 1)
      parMergesort :: Ord a => [a] -> Eval [a]
      parMergesort [] = pure []
      parMergesort [x] = pure [x]
      parMergesort xs = do
        l' <- rpar $ step l
        r' <- rseq $ step r
        pure $ l' `merge` r'
        where
          (l, r) = halve xs
