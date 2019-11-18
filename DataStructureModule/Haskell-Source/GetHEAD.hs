module GetHEAD (getHEAD) where

    getHEAD :: String -> Either String String
    getHEAD text  
        | length (words text) /= 2 = Left "Invalid input format"
        | head (words text) /= "Commit:" = Left "Invalid input format"
        | otherwise = Right (head (tail (words text)))