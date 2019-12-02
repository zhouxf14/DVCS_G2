require_relative 'init'
require_relative 'add'
require_relative 'remove'
require_relative 'clone'
require_relative 'status'
require_relative 'heads'
require_relative 'commit'
require_relative 'cat'
require_relative 'diff'
require_relative 'merge'
require_relative '../DataStructureModule/wrapper'
require 'rubygems'
require 'thor'
class Dvcs  < Thor
    include Init
    include Add
    desc "init","Create an empty repository"
    def init
        #creat a .dvcs folder in the local path
        #In .dvcs folder we have files: 
        #config:store the config of this repository: like the PATH of workspace,stage,repository
        #HEAD:store the point which indicate the current branch
        #index:store the list of files which stored in the temp stage 
        #In .dvcs folder we have folder: 
        #objects: to store all the data, include two sub folders one for the stage and another one for repository
        #ref: to store the points which point to the branch committed data object
        Init.create_repository(Dir.pwd)
        DataStructure.commit("Baby's first commit") # TODO: do we need to do this?
    end
  
    desc "add FILE_NAME","Add specific files that you want to track"
    def add(file_name)
      Add.add_file(file_name, Dir.pwd)
    end
    
    desc "clone PATH_URL","copy an existing repository"
    def clone(path_url, local_name)
      Clone.create_repository(Dir.pwd, path_url, local_path)
    end
  
    desc "remove PATH","Remove specific files from the tracking list"
    def remove(file_name)
      Remove.remove_file(file_name,Dir.pwd)
    end
  
    desc "status","Check the current status of the current repository"
    def status
      Status.check
    end
  
    desc "heads","Show the current heads"
    def heads
      Heads.return_back
    end
  
    desc "diff TARGET_VERSION","Check the changes between revisions"
    def diff(version1, version2=nil)
      Diff.diff_version(version1,version2=nil)
    end
  
    desc "cat PATH","Inspect a file of a given revision"
    def cat(path_filename, version_id=:options)
      Cat.inspect(path_filename)
    end
  
    desc "checkout BRANCH_NAME","Check out a specific revision"
    def checkout(bracnh_name)
      puts "this is checkout function the branch name is #{bracnh_name}"
    end
  
    desc "commit UPDATE_COMMENT","Commit changes"
    def commit(update_comment)      
      Commit.commit_stage(update_comment)
    end
  
    desc "log [<options>] [<revision range>] [[--] <path>…]","View the changelog"
    def log(options=:nah,range=:options,path=:suck) #And these aren't even optional options!
      puts DataStructure.log
    end
  
    desc "merge BRANCH_1, BRANCH_2","Merge two revisions"
    def merge(branch_1,branch_2)
        puts Merge.merge_return_back(branch_1, branch_2)
      # puts "this is merge function the branch1 is #{branch_1} the branch2 is #{branch_2}"
    end
  
    desc "pull REMOTE_LOCATION","Pull the changes from another repository"
    def pull(remote_location)
      puts "this is pull funciton the remote_location is #{remote_location}"
    end
  
    desc "push REMOTE_LOCATION","Push changes into another repository"
    def push(remote_location)
      puts "this is push function the remote_location is #{remote_location}"
    end
  
  end
module UserInterface

    def UserInterface.start
        Dvcs.start
    end
    
end
