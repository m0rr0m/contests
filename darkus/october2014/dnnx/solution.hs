import System.Environment (getArgs)
import Prelude as P
import qualified Control.Monad as CM
import Data.Bits ((.&.), shiftL, shiftR)
import Data.Set as Set

data Board = Board Int Int

boards :: Int -> [Board]
boards n = P.map (Board n . (*4)) [0..((1 `shiftL` ((n `div` 2)*n-2)) - 1)]

get :: Board -> Int -> Int -> Bool
get (Board n bits) i j =
  let halfN = n `div` 2
      code offset = (bits `shiftR` (2 * offset)) .&. 3
  in
    case (i >= halfN, j >= halfN) of
      (False, False) -> code (i * halfN + j) == 0
      (False,  True) -> code ((j - halfN) * halfN + (halfN - i - 1)) == 1
      ( True,  True) -> code ((n - i - 1) * halfN + (n - j - 1)) == 2
      ( True, False) -> code ((halfN - j - 1) * halfN + i - halfN) == 3

isGood :: Board -> Bool
isGood board@(Board n _) =
  let pairs = P.dropWhile (uncurry (==)) [(get board i j, get board j i)| i <- [0..(n-1)], j <- [0..(i-1)]]
  in case pairs of
       ((False, True):_) -> False
       _ -> True

connected :: Board -> Bool
connected board@(Board n _) =
  loop (Set.singleton (n-1, n-1)) [(n-1, n-1)] == n * n * 3 `div` 4
  where
    loop :: Set (Int, Int) -> [(Int, Int)] -> Int
    loop visited [] = Set.size visited
    loop visited ((x,y):queue) =
      let neighbours = [(x, y+1), (x+1, y), (x, y-1), (x-1, y)]
          goodNeighbours = P.filter isValid neighbours
          isValid (x', y') = 0 <= x' && x' < n && 0 <= y' && y' < n && not (get board x' y') && Set.notMember (x',y') visited
      in loop (visited `union` Set.fromList goodNeighbours) (goodNeighbours P.++ queue)

instance Show Board where
  show board@(Board n _) =
    unlines $ P.map (toLine . extractLine) [0..(n-1)]
    where
      extractLine :: Int -> [Bool]
      extractLine lineNo = P.map (get board lineNo) [0..(n-1)]
      toLine :: [Bool] -> String
      toLine = P.map toChar
      toChar bool = if bool then '#' else '.'

main :: IO ()
main = do
  args <- getArgs
  let n = read $ head args
  let brds = boards n
  CM.forM_ brds print
  -- print $ P.length brds
