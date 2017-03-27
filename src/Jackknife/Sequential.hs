module Jackknife.Sequential (jackknife) where

import Jackknife ( resamples )

jackknife :: ([a] -> b) -> [a] -> [b]
jackknife f = map f . resamples 500
