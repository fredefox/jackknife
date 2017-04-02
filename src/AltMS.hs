module AltMS where

import Control.Parallel (par,pseq)

--sorts elements into ascending order
mergesort :: Ord a => [a] -> [a]
mergesort [] = []
mergesort [x] = [x]
mergesort xs = do let (as,bs) = halve xs
                  merge (mergesort as) (mergesort bs)

pmergesort :: Ord a => Int -> [a] -> [a]
pmergesort gran xs
  | gran > 0 = case xs of
                [] -> []
                [x] -> [x]
                _ -> do let (as,bs) = halve xs
                            left = pmergesort (gran-1) as
                            right = pmergesort (gran-1) bs
                        as `seq`
                         bs `pseq`
                         (left `par` right `pseq`
                          (left `merge` right))
  | otherwise = mergesort xs

evalSpine [] = ()
evalSpine (_:xs) = evalSpine xs

halve xs = halve' [] [] xs
halve' as bs [] = (as,bs)
halve' as bs [a] = (a:as,bs)
halve' as bs (a:b:xs) = halve' (a:as) (b:bs) xs
merge [] bs = bs
merge as [] = as
merge (a:as) (b:bs) | a > b = b : merge (a:as) bs
                    | otherwise = a : merge as (b:bs)
{-
merge as [] = as
merge [] bs = bs
merge (a:as) (b:bs) = merge' a b as bs
merge' a b as bs =
  if a <= b
  then a : case as of
            [] -> b:bs
            a:as -> merge' a b as bs
  else b:case bs of
          [] -> a:as
          b:bs -> merge' a b as bs
-}
{-
merge (a,b,as,bs):
  if a <= b:
    output a
    if as == []: return b:bs
    a:as = as
    continue
  else:
    output b
    if bs == []: return a:as
    b:bs = bs
    continue
-}
