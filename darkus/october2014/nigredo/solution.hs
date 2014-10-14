import Data.List (intercalate, intersperse)
import qualified Data.HashSet as HS

data Quarter = 
          LeftTop 
        | RightTop 
        | RightBottom 
        | LeftBottom
             deriving (Enum, Eq, Show)

type Point = (Int, Int)

type Key = [Point]

main :: IO ()
main = do
  s <- getLine
  let n = read s :: Int
  let ks = intersperse "" $ prettySolve n
  mapM_ putStrLn ks

solve :: Int -> [String]
solve = map printKey . keys

prettySolve :: Int -> [String]
prettySolve n = map (prettyPrintKey n) (keys n)

points :: Int -> [Point]
points n =
    let row = [0..(n `div` 2 - 1)] in
    [(x, y) | x <- row, y <- row]

quarters :: [Quarter]
quarters = [LeftTop .. LeftBottom]

-- Все возможные комбинации поворотов для заданного набора точек
combinations :: [Point] -> [[Quarter]]
combinations ps = foldr (rCartesianWith (:))
                  [[]]
                  (map (const quarters) ps)

cartesianWith :: (a -> b -> c) -> [a] -> [b] -> [c]
cartesianWith f as bs = [f a b | a <- as, b <- bs]

rCartesianWith :: (a -> b -> c) -> [a] -> [b] -> [c]
rCartesianWith f as bs = [f a b | b <- bs, a <- as]

turn :: Int -> Point -> Quarter -> Point
turn n p LeftTop = p
turn n p RightTop = (n - 1 - snd p, fst p)
turn n p RightBottom = (n - 1 - fst p, n - 1 - snd p)
turn n p LeftBottom = (snd p, n - 1 - fst p)

keys :: Int -> [Key]
keys n =
    let 
        ps = points n
        -- Не поворачиваем первую точку, отсекая варианты с поворотами.
        cs = map (LeftTop:) (combinations $ tail ps) in
    filter (isValidKey n) $ map (zipWith (turn n) ps) cs

printKey :: Key -> String
printKey = intercalate ", " . map show

getKeyLines :: Int -> Key -> [String]
getKeyLines n key =
    map (\y ->
          map (\x -> 
               if elem (x, y) key
               then '.' 
               else 'x') 
         [0..n - 1])
       [0..n - 1]

prettyPrintKey :: Int -> Key -> String
prettyPrintKey n = intercalate "\n" . getKeyLines n

isValidKey :: Int -> Key -> Bool
isValidKey n key =
    let start = paperCells n key
        states = iterate stepFill (HS.singleton (head (HS.toList start)), start) in
    HS.null $ snd $ head $ filter (HS.null . fst) states

paperCells :: Int -> [Point] -> HS.HashSet Point
paperCells n key =
    let keyHS = HS.fromList key
        fullHS = HS.fromList $ cartesianWith (,) [0..n-1] [0..n-1] in
    HS.difference fullHS keyHS

stepFill :: (HS.HashSet Point, HS.HashSet Point) -> (HS.HashSet Point, HS.HashSet Point)
stepFill (activeCells, unfilledCells) =
    let newUC = unfilledCells `HS.difference` activeCells
        neighbours :: Point -> HS.HashSet Point
        neighbours (x, y) = 
            HS.fromList [(x - 1, y), (x + 1, y), (x, y + 1), (x, y - 1)]
        acNeighbours = 
            HS.foldr (\cell -> \acc -> acc `HS.union` (neighbours cell)) HS.empty activeCells
        newAC = acNeighbours `HS.intersection` newUC in
    (newAC, newUC)