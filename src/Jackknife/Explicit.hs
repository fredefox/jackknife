module Jackknife.Explicit (jackknife) where

import Control.Parallel

import qualified Jackknife.Sequential as Sequential (jackknife)
import Jackknife (resamples)

granularity :: Int
granularity = 1

jackknife :: ([a] -> b) -> [a] -> [b]
jackknife f = parMapChunked granularity f . resamples 500

-- | Parallel map with granularity control. It performs the map on parts of the
-- list of the specified size.
parMapChunked :: Int -> (a -> b) -> [a] -> [b]
parMapChunked threshold f xs = concat $ parMap (map f) $ chunksOf threshold xs

chunksOf _ [] = []
chunksOf n xs = l : chunksOf n r
  where
    (l, r) = splitAt n xs

parMap :: (a -> b) -> [a] -> [b]
parMap _ []       = []
parMap f (x : xs) = fx `par` fxs `pseq` fx : fxs
--                  ^divide^^^^^ and    ^conquer
  where
    fx  = f x
    fxs = parMap f xs
