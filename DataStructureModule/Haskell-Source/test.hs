import GetHEAD

main = do
    let Left e = (GetHEAD.getHEAD "What's the prob, ~~DOG~~?")
        Right m = (GetHEAD.getHEAD "Commit: 8472902891730498429198385732")    
    putStrLn m