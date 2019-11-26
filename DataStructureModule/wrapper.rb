require_relative '../FileProcessorModule/file_system'

require 'open3'
require 'digest'

module DataStructure

    CMD = "ghci -ibin -odir bin -v0 -fobject-code -ignore-dot-ghci -no-keep-hi-files"
    SOURCE_DIR = "Haskell-Source" #This is wrong :P

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
        return "Path added to tracking" if @@fp.append_text(INDEX, "#{file_path}\n")
        
        return "Failure adding path - unspecified file processing error"
    end
    
    def DataStructure.remove(file_path)
        #First see if it has alread been added
        added = false
        @@fp.read_lines(INDEX) {|line| added = added || File.realdirpath(line) == File.realdirpath(file_path)}
        if (added)
            if (@@fp.remove_line(INDEX,file_path))
                return "Removed file successfully"
            end
        else
            return "This file was never tracked; nothing to remove"
        end
    
    end

    def DataStructure.commit(message)
        #We can do the first bit of the file text right off the bat
        fileText = message + "\n" +
                   getUser() + "\n" +
                   Time.now.to_s + "\n" +
                   getHEAD() + "\n"
                
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
                puts "File #{line} does not exist."
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

    def DataStructure.HEADs
        return Hash[@@fp.list_contents(BRANCHES).map{|branch| [branch, @@fp.read(BRANCHES + branch)]}]
    end

    def DataStructure.checkout(branch)
        return "#{branch} is already checked out" if @@fp.read(CURRENT_BRANCH) == branch
        branches = @@fp.list_contents(BRANCHES)
        if !branches.member? branch
            @@fp.new_file(BRANCHES + branch, getHEAD())
            @@fp.new_file(CURRENT_BRANCH, branch)
            return "#{branch} added as new branch"
        else
            #Here I delete all the files in the repository
            #Then I build them all anew from the archives
            
            #Code I want but not yet
            #@@fp.new_file(HEAD, @@fp.read(BRANCHES + branch))
            #@@fp.new_file(CURRENT_BRANCH, branch)
            return "Oh no :O"
        end        
    end

    def DataStructure.status
        result = Hash.new; previousArchives = Hash.new; lineno = 0; head = getHEAD()
        
        @@fp.read_lines(COMMITS + head){ |line| 
            lineno += 1; 
            previousArchives.store(*line.split) if lineno > 4
        } unless head == "null"

        @@fp.read_lines(INDEX) { |line|
            if (@@fp.check_file_exists line)
                archiveName = hash(line + @@fp.read(line))
                if(previousArchives[line] == archiveName)
                    result[line] = "Committed"
                elsif(previousArchives[line] == nil)
                    result[line] = "Not Committed"
                else
                    result[line] = "Uncommitted Changes"
                end
            else
                result[line] = "Deleted"
            end
        }
        return result
    end

    def DataStructure.diff(version1, version2=nil)
        if version2==nil
            file_list=[]
            files=@@fp.get_all_files_name().split(/\n/) # get all workspace files
            previousArchives = Hash.new; lineno = 0; head = version1
            
            @@fp.read_lines(COMMITS + head){ |line|     # get all version2 files in repository
                lineno += 1; 
                previousArchives.store(*line.split) if lineno > 4
                } unless head == "null"
                files.each{ |line|                          #compare those files
                    len=line.length
                    filename=line[2,len]
                    if previousArchives.key?(filename)
                        puts "--------------------------------------------------------------"
                        puts "< : workspace "+filename
                        puts "> : repository"+filename+"->"+previousArchives[filename]
                        diff_result=@@fp.compare_files(line,ARCHIVES+previousArchives[filename])
                        if diff_result.nil?
                            puts "The are same"
                        else
                            puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                            puts diff_result
                            puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                        end                     
                    else
                        puts filename+" is a new file, has not been committed"                       
                    end
                    puts "--------------------------------------------------------------"
                }
        else 
            return 
        end
    end

end 

def main()
    puts DataStructure.checkout("master")
end      

if __FILE__ == $0
    main()
end
