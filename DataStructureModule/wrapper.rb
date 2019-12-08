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
    TEMP= ROOT + "objects/temp/"

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
    def DataStructure.merge_commit(merge_info,branch_1,branch_2)
        fileText = "Merge version1: "+branch_1+" version2: "+branch_2+ "\n" +
                   getUser() + "\n" +
                   Time.now.to_s + "\n" +
                   branch_1 +" "+ branch_2 + "\n"
    
        

        merge_info.each{ |compare_info|

            if compare_info["include_indicate"]
                fileText += compare_info["file_name"] + " " + compare_info["file_path"] + "\n"
            elsif compare_info["same_indicate"]
                fileText += compare_info["file_name"] + " " + compare_info["file_path"] + "\n"
            elsif compare_info["conflict_indicate"]

                @@fp.merge_two_file(ARCHIVES+compare_info["file_path_c1"],ARCHIVES+compare_info["file_path_c2"],TEMP+compare_info["file_name_c"])

                archiveName = hash(compare_info["file_name_c"] + @@fp.read(TEMP+compare_info["file_name_c"]))

                @@fp.store(TEMP+compare_info["file_name_c"], ARCHIVES + archiveName) unless @@fp.check_file_exists(ARCHIVES + archiveName)

                @@fp.remove_file(TEMP+compare_info["file_name_c"])

                fileText += compare_info["file_name_c"] + " " + archiveName +"\n"
            elsif compare_info["new_file_indicate"]
                fileText += compare_info["file_name"] + " " + compare_info["file_path"] + "\n"
            end
        }
        commitName = hash(fileText)
        @@fp.new_file(COMMITS + commitName, fileText)
        @@fp.new_file(HEAD, commitName)
        @@fp.new_file(BRANCHES + @@fp.read(CURRENT_BRANCH), commitName)
        
        return commitName.to_s

    end

    def DataStructure.log(commit = nil, output = "")
        commit = getHEAD() if !commit
        return output if commit == "null"
        commit=commit[0,40]
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
        diff_result_list=[]
        if version2==nil
            files=@@fp.get_all_files_name().split(/\n/) # get all workspace files
            previousArchives = Hash.new; lineno = 0; head = version1

            @@fp.read_lines(COMMITS + head){ |line|     # get all version1 files in repository
                lineno += 1; 
                previousArchives.store(*line.split) if lineno > 4
                } unless head == "null"
                
                files.each{ |line|                          #compare those files
                    len=line.length
                    filename=line[2,len]
                    compare_info={"new_file_indicate"=>nil,"version1"=>nil,"version2"=>nil,"file1"=>nil,"file2"=>nil,"file1_path"=>nil,"file2_path"=>nil,"diff_result"=>nil}
                    if previousArchives.key?(filename)
                        compare_info["new_file_indicate"]=nil
                        compare_info["version1"]="workspace"
                        compare_info["version2"]=head
                        compare_info["file1"]=filename
                        compare_info["file2"]=filename
                        compare_info["file1_path"]=line
                        compare_info["file2_path"]=ARCHIVES+previousArchives[filename]
                        #puts "--------------------------------------------------------------"
                        #puts "< : workspace "+filename
                        #puts "> : repository"+filename+"->"+previousArchives[filename]
                        # Compare the files between two version
                        diff_result=@@fp.compare_files(line,ARCHIVES+previousArchives[filename])
                        if diff_result.nil?
                            compare_info["diff_result"]="The are same"
                            #puts "The are same"
                        else
                            compare_info["diff_result"]=diff_result
                            #puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                            #puts diff_result
                            #puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                        end
                        diff_result_list.push(compare_info)                     
                    else
                        compare_info["new_file_indicate"]="version1"
                        compare_info["version1"]="workspace"
                        compare_info["file1"]=filename
                        compare_info["file1_path"]=line
                        #puts filename+" is a new file, has not been committed"
                        diff_result_list.push(compare_info)                       
                    end
                    #puts "--------------------------------------------------------------"

                }
            return diff_result_list
        else
            diff_result_list=[]
 
            previousArchives1 = Hash.new; lineno1 = 0; head1 = version1
            @@fp.read_lines(COMMITS + head1){ |line|     # get all version2 files in repository
                lineno1 += 1; 
                previousArchives1.store(*line.split) if lineno1 > 4
                } unless head1 == "null"

            previousArchives2 = Hash.new; lineno2 = 0; head2 = version2
            @@fp.read_lines(COMMITS + head2){ |line|     # get all version2 files in repository
                    lineno2 += 1; 
                    previousArchives2.store(*line.split) if lineno2 > 4
            } unless head1 == "null"
                
            previousArchives1.each{ |line|
                compare_info={"new_file_indicate"=>nil,"version1"=>nil,"version2"=>nil,"file1"=>nil,"file2"=>nil,"file1_path"=>nil,"file2_path"=>nil,"diff_result"=>nil}
                if previousArchives2.key?(line[0])
                    compare_info["new_file_indicate"]=nil
                    compare_info["version1"]=version1
                    compare_info["version2"]=version2
                    compare_info["file1"]=line[0]
                    compare_info["file2"]=line[0]
                    compare_info["file1_path"]=previousArchives1[line[0]]
                    compare_info["file2_path"]=previousArchives2[line[0]]
                    #puts "--------------------------------------------------------------"
                    #puts "< : version1: "+version1+" filename:"+line[0]
                    #puts "> : version2 "+version2+" filename:"+line[0]
                    diff_result=@@fp.compare_files(ARCHIVES+previousArchives1[line[0]],ARCHIVES+previousArchives2[line[0]])
                    if diff_result.nil?
                        compare_info["diff_result"]="The are same"
                        #puts "The are same"
                        diff_result_list.push(compare_info)
                    else
                        compare_info["diff_result"]=diff_result
                        #puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                        #puts diff_result
                        #puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                        diff_result_list.push(compare_info)
                    end
                else
                    compare_info["new_file_indicate"]="version1"
                    compare_info["version1"]=version1
                    compare_info["file1"]=line[0]
                    compare_info["file1_path"]=previousArchives1[line[0]]
                    #puts line[0]+" is a file in " + version1 + " not in " + version2
                    diff_result_list.push(compare_info)                    
                end
            }
            previousArchives2.each{ |line|
                compare_info={"new_file_indicate"=>nil,"version1"=>nil,"version2"=>nil,"file1"=>nil,"file2"=>nil,"file1_path"=>nil,"file2_path"=>nil,"diff_result"=>nil}
                if previousArchives1.key?(line[0])
                else
                    compare_info["new_file_indicate"]="version2"
                    compare_info["version2"]=version2
                    compare_info["file1"]=line[0]
                    compare_info["file1_path"]=previousArchives2[line[0]]
                    #puts line[0]+" is a file in " + version2 + " not in " + version1
                    diff_result_list.push(compare_info)                     
                end
            }
            return diff_result_list
        end
    end

    def DataStructure.repository_file_list(version)
        result = Hash.new; previousArchives = Hash.new; lineno = 0; head = version

        @@fp.read_lines(COMMITS + head){ |line|     # get all version2 files in repository
            lineno += 1; 
            previousArchives.store(*line.split) if lineno > 4
            } unless head == "null"
        
        return previousArchives
    
    end
    def DataStructure.search_commited(version)
        if version == "HEAD"
            return true
        else
            return @@fp.check_file_exists(COMMITS + version)
        end
    end
    # search the file in specify version if it exist in the version return the path of the file
    def DataStructure.search_commited_file(filename,version)
        if version=="HEAD"
            version=getHEAD()
        end
        result = Hash.new; previousArchives = Hash.new; lineno = 0; head = version
        @@fp.read_lines(COMMITS + head){ |line| 
            lineno += 1; 
            previousArchives.store(*line.split) if lineno > 4
        } unless head == "null"
        if previousArchives.key?(filename)
            return ARCHIVES+previousArchives[filename]
        else
            return nil
        end
    end

end 

def main()
    puts DataStructure.checkout("master")
end      

if __FILE__ == $0
    main()
end
