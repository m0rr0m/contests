import Data.List
import Data.Maybe
import Data.Char
import System.Environment

type Matrix a = [[a]]

symbol :: Int -> Matrix Int
symbol 0 = [[1, 1, 1],
            [1, 0, 1],
            [1, 0, 1],
            [1, 0, 1],
            [1, 1, 1]]
symbol 1 = [[1, 1, 0],
            [0, 1, 0],
            [0, 1, 0],
            [0, 1, 0],
            [1, 1, 1]]
symbol 2 = [[1, 1, 1],
            [0, 0, 1],
            [1, 1, 1],
            [1, 0, 0],
            [1, 1, 1]]
symbol 3 = [[1, 1, 1],
            [0, 0, 1],
            [1, 1, 1],
            [0, 0, 1],
            [1, 1, 1]]
symbol 4 = [[1, 0, 1],
            [1, 0, 1],
            [1, 1, 1],
            [0, 0, 1],
            [0, 0, 1]]
symbol 5 = [[1, 1, 1],
            [1, 0, 0],
            [1, 1, 1],
            [0, 0, 1],
            [1, 1, 1]]
symbol 6 = [[1, 1, 1],
            [1, 0, 0],
            [1, 1, 1],
            [1, 0, 1],
            [1, 1, 1]]
symbol 7 = [[1, 1, 1],
            [0, 0, 1],
            [0, 1, 1],
            [0, 1, 0],
            [0, 1, 0]]
symbol 8 = [[1, 1, 1],
            [1, 0, 1],
            [1, 1, 1],
            [1, 0, 1],
            [1, 1, 1]]
symbol 9 = [[1, 1, 1],
            [1, 0, 1],
            [1, 1, 1],
            [0, 0, 1],
            [1, 1, 1]]
symbol _ = undefined

symbolRows :: Matrix Int
symbolRows = nub $ [0..9] >>= transpose . symbol

readTranspose :: [String] -> Matrix Int
readTranspose = transpose . map (map digitToInt)

symbolIndeces :: Matrix Int -> [(Int, Int)]
symbolIndeces x = sort $ symbolSndIndeces $ zip fstInd [0..]
  where fstInd = map (symbolFstIndeces . zip [0..]) x

symbolSndIndeces :: [([Int], Int)] -> [(Int, Int)]
symbolSndIndeces arr = slices >>= coords
  where slices                = filter (\x -> length x >= 3) slicesAll
        slicesAll             = scanr (\x xs -> x : take 2 xs) [] arr
        coords ((xs, y) : zs) = zip (filter areThreeRows xs) $ repeat y
          where areThreeRows x = all (x `elem`) $ map fst zs

symbolFstIndeces :: [(Int, Int)] -> [Int]
symbolFstIndeces arr = map (fst . head) $ filter isSymbolRow slices
  where isSymbolRow x = map snd x `elem` symbolRows
        slices        = filter (\x -> length x >= 5) slicesAll
        slicesAll     = scanr (\x xs -> x : take 4 xs) [] arr

getArea :: Matrix Int -> (Int, Int) -> Matrix Int
getArea mx (x, y) = map (take 5 . drop x) rows
  where rows = (take 3 . drop y) mx

findSymbols :: Matrix Int -> [(Int, Int)] -> [Int]
findSymbols mx zs = zs >>= maybeToList . getSymbol
  where getSymbol :: (Int, Int) -> Maybe Int
        getSymbol coords = find (isSymbol coords) [0..9]
        isSymbol :: (Int, Int) -> Int -> Bool
        isSymbol coords x = getArea mx coords == (transpose . symbol) x

main :: IO ()
main = do
  [fname] <- getArgs
  content <- readFile fname
  let fileLines = lines content
      matrix    = readTranspose fileLines
      coords    = symbolIndeces matrix
  putStrLn $ map intToDigit $ findSymbols matrix coords
