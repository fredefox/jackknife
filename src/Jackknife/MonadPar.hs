module Jackknife.MonadPar (jackknife) where

import           Control.Monad.Par        (runPar, NFData, Par)
import qualified Control.Monad.Par as Par (parMap)

import Jackknife (resamples)

granularity :: Int
granularity = 50

jackknife :: NFData b => ([a] -> b) -> [a] -> [b]
jackknife f = runPar . parMapChunked granularity f . resamples 500

-- | Restricts the type of `Par.parMap` to avoid ambiguity.
parMap :: NFData b => (a -> b) -> [a] -> Par [b]
parMap = Par.parMap

-- | Parallel map with granularity control. It performs the map on parts of the
-- list of the specified size.
parMapChunked :: NFData b => Int -> (a -> b) -> [a] -> Par [b]
parMapChunked threshold f xs = concat <$> parMap (map f) (chunksOf threshold xs)

chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n xs = l : chunksOf n r
  where
    (l, r) = splitAt n xs
