module Jackknife ( resamples ) where

import Data.List (inits, tails)

resamples :: Int -> [a] -> [[a]]
resamples k xs =
    take (length xs - k) $
    zipWith (++) (inits xs) (map (drop k) (tails xs))
