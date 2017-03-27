module Main ( main ) where

import Data.List
import System.Random
import Criterion.Main

import qualified Jackknife.Sequential as Sequential (jackknife)
import qualified Jackknife.Explicit   as Explicit   (jackknife)
import qualified Jackknife.Eval       as Eval       (jackknife)
import qualified Jackknife.Strat      as Strat      (jackknife)
import qualified Jackknife.MonadPar   as MonadPar   (jackknife)

-- code borrowed from the Stanford Course 240h (Functional Systems in Haskell)
-- I suspect it comes from Bryan O'Sullivan, author of Criterion

data T a = T !a !Int


mean :: (RealFrac a) => [a] -> a
mean = fini . foldl' go (T 0 0)
  where
    fini (T a _) = a
    go (T m n) x = T m' n'
      where m' = m + (x - m) / fromIntegral n'
            n' = n + 1


crud :: [Float] -> [Float]
crud = zipWith (\x a -> sin (x / 300)**2 + a) [0..]

main :: IO ()
main = do
  let (xs,ys) = splitAt 1500  (take 6000
                               (randoms (mkStdGen 211570155)) :: [Float] )
  -- handy (later) to give same input different parallel functions

  let rs = crud xs ++ ys
  putStrLn $ "sample mean:    " ++ show (mean rs)

  let j = jackknife mean rs :: [Float]
  putStrLn $ "jack mean min:  " ++ show (minimum j)
  putStrLn $ "jack mean max:  " ++ show (maximum j)
  defaultMain
    [ bench "[sequential] jackknife" (nf (Sequential.jackknife  mean) rs)
    , bench "[explicit]   jackknife" (nf (Explicit.jackknife    mean) rs)
    , bench "[eval]       jackknife" (nf (Eval.jackknife        mean) rs)
    , bench "[strat]      jackknife" (nf (Strat.jackknife       mean) rs)
    , bench "[monad-par]  jackknife" (nf (MonadPar.jackknife    mean) rs)
    ]
