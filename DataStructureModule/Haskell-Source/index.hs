import System.IO
import System.Environment
import qualified Data.Map as Map
import GetHEAD

commandMap = Map.fromList [("getHEAD", GetHEAD.getHEAD)]

outputResult :: Either String String -> IO ()
outputResult (Left error) = hPutStrLn stderr error
outputResult (Right result) =  hPutStrLn stdout result

main = do
    --putStrLn "Oh no!"
    (command:rawInput) <- getArgs
    if Map.member command commandMap
        then outputResult $ (commandMap Map.! command) (unwords rawInput)
        else putStrLn "Invalid command"

        {-
main = do
    allArgs <- getArgs
    print allArgs
    -}