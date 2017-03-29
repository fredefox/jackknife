module MergeSort.Util (mergesort, merge, halve) where

-- | Sequential reference implementation
mergesort :: Ord a => [a] -> [a]
mergesort [] = []
mergesort [x] = [x]
mergesort xs = l' `merge` r'
  where
    (l, r) = halve xs
    l' = mergesort l
    r' = mergesort r

merge :: Ord a => [a] -> [a] -> [a]
merge []           ys           = ys
merge xs           []           = xs
merge xs@(x : xss) ys@(y : yss) = case compare x y of
  LT -> x : merge xss ys
  _  -> y : merge xs  yss

halve :: [a] -> ([a], [a])
halve xs = splitAt (n `div` 2) xs
  where
    n = length xs
