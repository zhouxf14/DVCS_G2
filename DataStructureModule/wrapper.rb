require_relative '../file_system'

require 'open3'
require 'digest'

module DataStructure

    CMD = "ghci -ibin -odir bin -v0 -fobject-code -ignore-dot-ghci -no-keep-hi-files"
    SOURCE_DIR = "Haskell-Source"

    ROOT = "./.dvcs/"
    INDEX = ROOT + "index"
    HEAD = ROOT + "HEAD"
    OBJECTS = ROOT + "objects/"
    COMMITS = OBJECTS + "commits/"
    ARCHIVES = OBJECTS + "archives/"
    BRANCHES = ROOT + "refs/"
    CURRENT_BRANCH = ROOT + "info/branch"

    class FS
        include FileSystem
    end
    private_constant :FS

    private def runHaskell(script)
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
    
    private def DataStructure.hash(string)
        return Digest::SHA1.hexdigest string
    end

    @@fp = FS.new

    def DataStructure.getHEAD_old(str)
        script = ":cd " + SOURCE_DIR + "\n" +
                ":load GetHEAD.hs\n" +
                ":main " + str + "\n" +
                ":quit"
    
        return runHaskell(script)
    end

    def DataStructure.getHEAD()
        return @@fp.get_line(HEAD, 1)
    end

    def DataStructure.getUser()
        return ENV['USERNAME'] || ENV['USER']
    end

    def DataStructure.add(file_path)
        #First see if it has already been added
        added = false
        @@fp.read_lines(INDEX) {|line| added = added || File.realdirpath(line) == File.realdirpath(file_path)}        
        return "This file is already being tracked" if(added)
        
        #Now we do the hard work of adding the file
        return "Uh, it worked I suppose" if @@fp.append_text(INDEX, "#{file_path}\n")
        
        return "Ah it actually failed for an unspecified file processing error"
    end

    def DataStructure.commit(message)
        head = getHEAD()
        #We can do the first bit of the file text right off the bat
        fileText = message + "\n" +
                   getUser() + "\n" +
                   Time.now.to_s + "\n" +
                   head + "\n"
        
        #Now we do the hard part of insuring all our tracked files are archived and accounted for

        #Start by gathering up the previous commit's info
        #previousArchives = Hash.new; lineno = 0
        
        #@@fp.read_lines(COMMITS + head){ |line| 
        #    lineno += 1; 
        #    previousArchives.store(*line.split) if lineno > 4
        #} unless head == "null"
                
        #Next iterate through the list of tracked files
        @@fp.read_lines(INDEX) { |line|
            if (@@fp.check_file_exists line)
                archiveName = hash(line + @@fp.read(line))
                @@fp.store(line, ARCHIVES + archiveName) unless @@fp.check_file_exists(ARCHIVES + archiveName)
                fileText += line + " " + archiveName + "\n"
                
                #if previousArchives[line]
                #    if(@@fp.retrieve(previousArchives[line]) == @@fp.read(line))
                #        puts "Same"
                #        fileText += line + " " + previousArchives[line] + "\n"
                #    else
                #        puts "Diff"
                #        archiveName = hash(line + @@fp.read(line))
                #        @@fp.store(line, ARCHIVES + archiveName)
                #        fileText += line + " " + archiveName + "\n"
                #    end
                #else
                #    archiveName = hash(line + @@fp.read(line))
                #    @@fp.store(line, ARCHIVES + archiveName)
                #    fileText += line + " " + archiveName + "\n"
                #end
            else
                #TODO - If file doesn't exist we can presumably remove it from the index
                puts "Oh wow, #{line} was deleted by the user and so will be ignored by commit"
            end
        }

        commitName = hash(fileText)
        @@fp.new_file(COMMITS + commitName, fileText)
        @@fp.new_file(HEAD, commitName)
        @@fp.new_file(BRANCHES + @@fp.read(CURRENT_BRANCH), commitName)
    end
end 

def main()
    #fp = FS.new
    #fp.new_folder ".\\daryl"
    #puts DataStructure.getHEAD("Commit: 123454324342") 

    #puts(DataStructure.add "daryl.txt")
    #DataStructure.getHEAD()

    DataStructure.commit($*[0] || "Pleib diddn leave no message")
    #p DataStructure.getUser()
end      

if __FILE__ == $0
    main()
end