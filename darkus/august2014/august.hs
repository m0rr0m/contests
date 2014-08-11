import Data.Char
import Data.List.Split
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

symbolToLines = 
    let lineToString = map (\a -> intToDigit a) in 
    map lineToString 

printMatrix m = mapM_ putStrLn (symbolToLines m)

ncol = 1000

separator = [[0],[0],[0],[0],[0]] :: Matrix Int
hr = [replicate (4*ncol + 1) 0] :: Matrix Int

mergeMatrices a b = map (\(x,s,y) -> x ++ s ++ y) $ zip3 a separator b

bigMatrix :: String -> [Matrix Int]
bigMatrix digits = let 
        chunks = chunksOf ncol digits
        chunkToSymbols = map (symbol . digitToInt) 
        addFinalSeparator m = map (\(y,s) -> y ++ s) $ zip m separator
    in map (\c -> addFinalSeparator . foldl mergeMatrices [[],[],[],[],[]] $ (chunkToSymbols c)) chunks

main = do
    [filename] <- getArgs
    str <- readFile filename
    printMatrix hr
    mapM_ (\chunk -> printMatrix chunk >> printMatrix hr) $ bigMatrix str
