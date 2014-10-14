import qualified RotatingKey as R

import System.Environment

main = do
    [n] <- getArgs
    print . R.main . read $ n
