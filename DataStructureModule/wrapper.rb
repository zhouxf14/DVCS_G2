require_relative '../file_system'

require 'open3'

CMD = "ghci -ibin -odir bin -v0 -fobject-code -ignore-dot-ghci -no-keep-hi-files"
SOURCE_DIR = "Haskell-Source"

ROOT = "./dvcs/"
INDEX = ROOT + "index"

class FS
    include FileSystem
end

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

module DataStructure
    def DataStructure.getHEAD(str)
        script = ":cd " + SOURCE_DIR + "\n" +
                ":load GetHEAD.hs\n" +
                ":main " + str + "\n" +
                ":quit"

        return runHaskell(script)
    end

    def DataStructure.add(file_path)
        fp = FS.new
        #First see if it has already been added
        added = false
        fp.read_lines(INDEX) {|line| added = added || File.realdirpath(line) == File.realdirpath(file_path)}        
        return "This file is already being tracked" if(added)
        
        #Now we do the hard work of adding the file
        fp.append_text("#{file_path}\n",INDEX)
        return "Uh, it worked I suppose"
    end
end 

def main()
    #fp = FS.new
    #fp.new_folder ".\\daryl"
    #puts DataStructure.getHEAD("Commit: 123454324342") 

    puts(DataStructure.add "daryl.txt")
end      

main()