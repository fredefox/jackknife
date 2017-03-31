module Main (main) where

import Control.Parallel
import Control.DeepSeq

import Jackknife (resamples)
import System.Random

crud :: [Float] -> [Float]
crud = zipWith (\x a -> sin (x / 300)**2 + a) [0..]

main :: IO ()
main = do
  let (xs,ys) = splitAt 1500  (take 6000
                               (randoms (mkStdGen 211570155)) :: [Float] )
  let rs  = crud xs ++ ys
      rs' = resamples 500 (rs :: [Float])
  evaluate rs'
  -- print . length $ rs'

-- | This will force the evaluation of the argument since bind in IO is strict.
evaluate :: NFData a => a -> IO ()
evaluate x = rnf x `pseq` return ()
