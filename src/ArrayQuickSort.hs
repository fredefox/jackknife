module ArrayQuickSort where

import Data.Array.MArray
import Data.Array.IO
import Control.Concurrent
import System.IO.Unsafe

--Testing
import Test.QuickCheck
prop_qsort :: [Int] -> Bool
prop_qsort xs = ordered $ qsort xs
prop_pqsort :: [Int] -> Bool
prop_pqsort xs = ordered $ pqsort xs
ordered [] = True
ordered (x:xs) = ordered' x xs
  where ordered' _ [] = True
        ordered' x (y:xs) = x <= y && ordered' y xs
test = quickCheck prop_qsort

--Note: the parts which guarantee there are no race conditions have been
--commented out, but it seems to produce the correct result anyway
pqsort :: Ord a => [a] -> [a]
pqsort xs = unsafePerformIO $ do
  let last = length xs - 1
  arr <- newListArray (0, last) xs
  pInPlaceQSort arr 0 last
  getElems arr
pInPlaceQSort :: Ord a => IOArray Int a -> Int -> Int -> IO ()
pInPlaceQSort arr f l | l <= f = return ()
                      | l - f <= 10000 = inPlaceQSort arr f l
                      | otherwise = do
  p <- splitPivot arr f l --p is the pointer to the pivot element
  --mv <- newEmptyMVar
  forkIO $ do inPlaceQSort arr f (p-1)
              --putMVar mv ()
  inPlaceQSort arr (p+1) l
  --takeMVar mv

--in-place mergesort is nontrivial, I'll do quicksort instead
qsort :: Ord a => [a] -> [a]
qsort xs = unsafePerformIO $ do
  let last = length xs - 1
  arr <- newListArray (0, last) xs
  inPlaceQSort arr 0 last
  getElems arr

inPlaceQSort :: Ord a => IOArray Int a -> Int -> Int -> IO ()
inPlaceQSort arr f l | l <= f = return ()
inPlaceQSort arr f l = do
  p <- splitPivot arr f l --p is the pointer to the pivot element
  inPlaceQSort arr f (p-1)
  inPlaceQSort arr (p+1) l
splitPivot :: Ord a => IOArray Int a -> Int -> Int -> IO Int
splitPivot arr f l
  | f == l = return l
  | f + 1 == l = do
      cand <- read f
      pivot <- read l
      if cand > pivot
         then do
        write f pivot
        write l cand
        return f
        else return l
  | otherwise = do
      cand <- read f
      pivot <- read l
      if cand >= pivot
         then do
        write l cand
        displaced <- read (l-1)
        write (l-1) pivot
        write f displaced
        splitPivot arr f (l-1)
        else splitPivot arr (f+1) l
  where write = writeArray arr
        read = readArray arr
                       
