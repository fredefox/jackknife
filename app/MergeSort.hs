module Main (main) where

import System.Random
import Control.DeepSeq (NFData, rnf)
import Criterion.Main
import Control.Parallel

import qualified MergeSort.Style.Sequential as Sequential (mergesort)
import qualified MergeSort.Style.Explicit   as Explicit   (mergesort)
import qualified AltMS
-- TODO Implement some of these:
import qualified MergeSort.Style.Eval       as Eval       (mergesort)
-- import qualified MergeSort.Style.Strat      as Strat      (mergesort)
-- import qualified MergeSort.Style.MonadPar   as MonadPar   (mergesort)

doBenchmark :: [Float] -> IO ()
doBenchmark rs =
  defaultMain
    [ bench "altms sequential" $ nf AltMS.mergesort rs
    , bench "altms explicit" $ nf (AltMS.pmergesort 2) rs  
    , bench "[sequential] mergesort" (nf Sequential.mergesort rs)
    , bench "[explicit]   mergesort" (nf Explicit.mergesort   rs)
    , bench "[eval]       mergesort" (nf Eval.mergesort       rs)
    -- , bench "[strat]      mergesort" (nf Strat.mergesort      rs)
    -- , bench "[monad-par]  mergesort" (nf MonadPar.mergesort   rs)
    ]

aList :: [Float]
aList = take 100000 $ randoms (mkStdGen 1337)

main :: IO ()
main = doBenchmark aList
--main = evaluate . Explicit.mergesort $ aList

evaluate :: NFData a => a -> IO ()
evaluate x = rnf x `pseq` return ()
