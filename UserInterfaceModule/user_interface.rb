require_relative 'UserInterfaceModule/init'
require_relative 'UserInterfaceModule/add'
require_relative 'UserInterfaceModule/clone'
require_relative 'DataStructureModule/wrapper'
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
        DataStructure.commit("Baby's first commit")
    end
  
    desc "add FILE_NAME","Add specific files that you want to track"
    def add(file_name)
      #TODO - check that the path is valid and that the file exists
      #puts "this is add function file name is #{file_name}"
      Add.add_file(file_name,Dir.pwd)
    end
    
    desc "clone PATH_URL","copy an existing repository"
    def clone(path_url)
      # puts "this is clone function the path or url is #{path_url}"
      Clone.create_repository(Dir.pwd)
    end
  
    desc "remove PATH","Remove specific files from the tracking list"
    def remove(path)
      puts "this is remove function the path is #{path}"
    end
  
    desc "status","Check the current status of the current repository"
    def status
      puts DataStructure.status
    end
  
    desc "heads","Show the current heads"
    def heads
      puts DataStructure.HEADs
    end
  
    desc "diff TARGET_VERSION","Check the changes between revisions"
    def diff(target_version)
      puts "this is diff function the target_vesrsion is #{target_version}"
    end
  
    desc "cat PATH","Inspect a file of a given revision"
    def cat(path_filename)
      puts "this is cat funciton,the path is #{path_filename}"
    end
  
    desc "checkout BRANCH_NAME","Check out a specific revision"
    def checkout(bracnh_name)
      puts "this is checkout function the branch name is #{bracnh_name}"
    end
  
    desc "commit UPDATE_COMMENT","Commit changes"
    def commit(update_comment)      
      puts "Commit successful - #{DataStructure.commit update_comment}"
    end
  
    desc "log [<options>] [<revision range>] [[--] <path>…]","View the changelog"
    def log(options=:nah,range=:options,path=:suck) #And these aren't even optional options!
      puts DataStructure.log
    end
  
    desc "merge BRANCH_1, BRANCH_2","Merge two revisions"
    def merge(branch_1,branch_2)
      puts "this is merge function the branch1 is #{branch_1} the branch2 is #{branch_2}"
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
