{-# OPTIONS_HADDOCK prune, ignore-exports #-}

{------------------------------------------------------------------------------}
{- | августовский конкурс по ФП в 2014 году.

   Автор:     Душкин Р. В.
   Проект:    FPContest

   Задача: поиск подматриц в матрицах.
   
   
                                                                              -}
{------------------------------------------------------------------------------}

module RoS
(
  -- * Функции
  main
)
where

{-[ СЕКЦИЯ ИМПОРТА ]-----------------------------------------------------------}

import Control.Arrow ((&&&))
import Control.Monad (liftM)

{-[ СИНОНИМЫ ТИПОВ ]-----------------------------------------------------------}

-- | Тип для представления одной строки матрицы (вектора). Представляет собой
--   список.
type Vector a = [a]

-- | Тип для представления матрицы. Представляет собой список векторов (то есть
--   список списков). Разработчик должен самостоятельно следить за тем, чтобы
--   размерность всех векторов (длины списков) были одинаковыми.
type Matrix a = [Vector a]

{-[ ФУНКЦИИ ]------------------------------------------------------------------}

-- | Функция для представления символов цифр от 0 до 9.
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

-- | Сервисная функция для вывода на экран заданного символа в приятном виде.
printSymbol :: Matrix Int -> IO ()
printSymbol = mapM_ (\l -> mapM_ printSymbol' l >> putStrLn "")
  where
    printSymbol' s = case s of
                       0 -> putStr " "
                       1 -> putStr "#"
                       _ -> undefined

-- | Функция для чтения матрицы для распознавания из файла.
loadMatrix :: FilePath -> IO (Matrix Int)
loadMatrix = liftM (map (map (\c -> read [c])) . lines) . readFile

-- | Сервисная функция для вычисления размерности заданной матрицы.
getMatrixDimension :: Matrix a -> (Int, Int)
getMatrixDimension = (length . head) &&& length

-- | Сервисная функция для получения подматрицы с заданной позиии заданного
--   размера. Разработчик самостоятельно должен следить за размерностями
--   матрицы и получаемой подматрицы. Функция небезопасна.
subMatrix :: (Int, Int) -> (Int, Int) -> Matrix a -> Matrix a
subMatrix (x, y) (w, h) = map (take w . drop x) . take h . drop y

-- | Функция для поиска подматрицы в матрице.
findSymbol sm m = [(x, y) | x <- [0..mw - sw],
                            y <- [0..mh - sh],
                            sm == subMatrix (x, y) (sw, sh) m]
  where
    (sw, sh) = getMatrixDimension sm
    (mw, mh) = getMatrixDimension m

-- | Функция для вывода на экран информации о найденных символах.
prettyPrint :: [(Integer, [(Int, Int)])] -> IO ()
prettyPrint = mapM_ prettyPrint'
  where
    prettyPrint' (_, [])          = return ()
    prettyPrint' (n, xs@[(_, _)]) = putStrLn ("Символ " ++ show n ++ " обнаружен на позиции  " ++ printCoordinates xs ++ ".")
    prettyPrint' (n, xs)          = putStrLn ("Символ " ++ show n ++ " обнаружен на позициях " ++ printCoordinates xs ++ ".")

    printCoordinates []          = ""
    printCoordinates [(x, y)]    = "(" ++ show x ++ ", " ++ show y ++ ")"
    printCoordinates ((x, y):xs) = "(" ++ show x ++ ", " ++ show y ++ "), " ++ printCoordinates xs

-- | Главная функция модуля. Запускает программу на исполнение.
main :: IO ()
main = do putStr "Введите имя файла с матрицей: "
          fn <- getLine
          m  <- loadMatrix fn
          prettyPrint $ zip [0..9] $ map (\i -> findSymbol (symbol i) m) [0..9]

{-[ КОНЕЦ МОДУЛЯ ]-------------------------------------------------------------}
