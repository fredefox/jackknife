module Jackknife.Explicit (jackknife) where

import Control.Parallel

import qualified Jackknife.Sequential as Sequential (jackknife)
import Jackknife (resamples)

granularity :: Int
granularity = 10

jackknife :: NFData b => ([a] -> b) -> [a] -> [b]
jackknife f = parMapChunked granularity f . resamples 500

-- | Parallel map with granularity control. It performs the map on parts of the
-- list of the specified size.
parMapChunked :: NFData b => Int -> (a -> b) -> [a] -> [b]
parMapChunked threshold f xs = concat $ parMap (map f) $ chunksOf threshold xs

chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n xs = l : chunksOf n r
  where
    (l, r) = splitAt n xs

parMap :: NFData b => (a -> b) -> [a] -> [b]
parMap _ []       = []
parMap f (x : xs) = rnf fx `par` (rnf fxs `pseq` fx : fxs)
--                  ^divide^^^^^^^^^^^^^ and    ^conquer
  where
    fx  = f x
    fxs = parMap f xs

class NFData a where
  rnf :: a -> ()

instance NFData Float where
  rnf _ = ()

instance NFData a => NFData [a] where
  rnf [] = ()
  rnf (x : xs) = rnf x `pseq` rnf xs
