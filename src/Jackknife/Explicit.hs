module Jackknife.Explicit (jackknife) where

import Control.Parallel

import qualified Jackknife.Sequential as Sequential (jackknife)
import Jackknife (resamples)

granularity :: Int
granularity = 10

-- jackknife :: NFData b => ([a] -> b) -> [a] -> [b]
-- jackknife f xs = parMapChunked granularity f (resamples 500 xs)
jackknife f = parMap f . resamples 500

force :: NFData b => b -> b
force x = rnf x `pseq` x

-- | Parallel map with granularity control. It performs the map on parts of the
-- list of the specified size.
-- parMapChunked :: NFData b => Int -> (a -> b) -> [a] -> [b]
parMapChunked threshold f xs = concat $ parMap (map f) $ evaluate $ chunksOf threshold xs
-- parMapChunked threshold f xs = concat $ map (parMap f) $ chunksOf threshold xs

chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n xs = l : chunksOf n r
  where
    (l, r) = splitAt n xs

evaluate :: NFData a => a -> a
evaluate x = rnf x `pseq` x

-- parMap :: NFData b => (a -> b) -> [a] -> [b]
-- parMap _ []       = []
-- parMap f (x : xs) = fx `par` (fxs `pseq` fx : fxs)
-- --                  ^divide^^^^^^^^^^^^^ and    ^conquer
--   where
--     fx  = f x
--     fxs = parMap f xs
parMap :: (a -> b) -> [a] -> [b]
parMap = pMap

pMap :: (a -> b) -> [a] -> [b]
pMap f [] = []
pMap f (x:xs) =
  let
    x'  = f x
    xs' = pMap f xs
  in
    x' `par` (xs' `pseq` (x' : xs'))

class NFData a where
  rnf :: a -> ()

instance NFData Float where
  rnf f = f `pseq` ()

instance NFData a => NFData [a] where
  rnf [] = ()
  rnf (x : xs) = rnf x `pseq` rnf xs
