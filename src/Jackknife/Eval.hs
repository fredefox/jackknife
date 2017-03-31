module Jackknife.Eval (jackknife) where

import Control.Parallel.Strategies hiding (parListChunk, parMap)

import qualified Jackknife.Sequential as Sequential (jackknife)

granularity :: Int
granularity = 20

jackknife :: NFData b => ([a] -> b) -> [a] -> [b]
jackknife f xs = (Sequential.jackknife f xs) `using` parListChunk granularity rdeepseq

-- | (Re-)implementation of `Control.Parallel.Strategies.parListChunk`
-- parListChunk :: Int -> Strategy a -> Strategy [a]
parListChunk _    _     []       = return []
parListChunk size strat xs = do
  (as,bs) <- rdeepseq $ splitAt size xs
  xs' <- rpar (map (`using`strat) as)
  ys <- parListChunk size strat bs
  _ <- rdeepseq ys
  pure $ xs' ++ ys
