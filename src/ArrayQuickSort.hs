module ArrayQuickSort where

import Data.Array.MArray
import Data.Array.IO
import Control.Concurrent
import System.IO.Unsafe

--Testing
import Test.QuickCheck
prop_qsort :: [Int] -> Bool
prop_qsort xs = ordered $ qsort xs
ordered [] = True
ordered (x:xs) = ordered' x xs
  where ordered' _ [] = True
        ordered' x (y:xs) = x <= y && ordered' y xs
test = quickCheck prop_qsort

--Slice arr f l includes the indexes f..l-1
data Slice a = Slice {sliceArray :: IOArray Int a,
                      firstIx :: Int,
                      lastIx :: Int}
toSlice :: IOArray Int a -> IO (Slice a)
toSlice arr = do (first,last) <- getBounds arr
                 return $ Slice arr first (last+1)
halve sl = (takeSlice n sl, dropSlice n sl)
  where n = len `div` 2 + len `rem` 2
        len = lengthSlice sl
lengthSlice (Slice _ f l) = l-f
takeSlice n (Slice arr f l) = Slice arr f (min (f+n) l)
dropSlice n (Slice arr f l) = Slice arr (min (f+n+1) l) l
--NOTE: readSlice does not do bounds checking
readSlice :: Int -> Slice a -> IO a
readSlice n (Slice arr f _) = readArray arr (f+n)
writeSlice :: Int -> a -> Slice a -> IO ()
writeSlice n e (Slice arr f _) = writeArray arr (f+n) e
listSlice :: [a] -> IO (Slice a)
listSlice xs = do
  let len = length xs
  arr <- newListArray (0, len - 1) xs
  return $ Slice arr 0 len
sliceToList :: Slice a -> IO [a]
sliceToList (Slice arr f l) = sliceToList' arr f l
sliceToList' arr f l | f == l = return []
                     | otherwise = do x <- readArray arr 0
                                      xs <- sliceToList' arr (f+1) l
                                      return $ x:xs

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
                       
