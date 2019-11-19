import System.IO
import System.Environment

outputResult :: Either String String -> IO ()
outputResult (Left error) = hPutStrLn stderr error
outputResult (Right result) =  hPutStrLn stdout result

getHEAD :: String -> Either String String
getHEAD text  
    | length (words text) /= 2 = Left "Invalid input format"
    | head (words text) /= "Commit:" = Left "Invalid input format"
    | otherwise = Right (head (tail (words text)))

main = do
    rawInput <- getArgs
    outputResult $ getHEAD (unwords rawInput)