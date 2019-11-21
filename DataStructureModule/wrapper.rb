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
                
        #Next iterate through the list of tracked files, and insure we have archives
        @@fp.read_lines(INDEX) { |line|
            # We have to check if the file still exists and ignore it if it doesn't
            if (@@fp.check_file_exists line)
                # This part is deceptively simple
                # Because each archived file has a unique name based on it's name AND content
                # All we have to do is check if a file with that unique name exists
                # They're guaranteed to match content! So we don't have to rearchive 
                # or check an old commit or do any sor of file comparison.
                archiveName = hash(line + @@fp.read(line))
                @@fp.store(line, ARCHIVES + archiveName) unless @@fp.check_file_exists(ARCHIVES + archiveName)
                fileText += line + " " + archiveName + "\n"
            else
                #TODO - If file doesn't exist we can presumably remove it from the index
                puts "Oh wow, #{line} was deleted by the user and so will be ignored by commit"
            end
        }

        #Now we just make the commit file and update the branch pointer and HEAD pointer
        commitName = hash(fileText)
        @@fp.new_file(COMMITS + commitName, fileText)
        @@fp.new_file(HEAD, commitName)
        @@fp.new_file(BRANCHES + @@fp.read(CURRENT_BRANCH), commitName)

        return commitName
    end

    def DataStructure.log(commit = nil, output = "")
        commit = getHEAD() if !commit
        return output if commit == "null"

        return log(@@fp.get_line(COMMITS + commit,4),
            output +
            "commit " + commit + "\n" +
            "Author:\t" + @@fp.get_line(COMMITS + commit,2) + "\n" +
            "Date:\t" + @@fp.get_line(COMMITS + commit,3) + "\n" +
            "\n\t" + @@fp.get_line(COMMITS + commit,1) + "\n\n"
        ) 
    end

end 

def main()
    puts DataStructure.log()
end      

if __FILE__ == $0
    main()
end