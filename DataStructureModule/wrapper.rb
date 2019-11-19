require 'open3'

CMD = "ghci -ibin -odir bin -v0 -fobject-code -ignore-dot-ghci -no-keep-hi-files"
SOURCE_DIR = "Haskell-Source"

def runHaskell(script)
    err = ""; result = ""
    
    Open3.popen3(CMD) do |stdin, stdout, stderr, wait_thr|
        stdin.puts script
        stdin.close

        err = stderr.read
        result = stdout.read        
    end

    return result unless err != ""
    raise err
end

def getHEAD(str)
    script = ":cd " + SOURCE_DIR + "\n" +
             ":load GetHEAD.hs\n" +
             ":main " + str + "\n" +
             ":quit"

    return runHaskell(script)
end

def main()
    puts getHEAD("Commit: 123454324342") 
end      

main()