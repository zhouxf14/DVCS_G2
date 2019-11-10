require 'rubygems'
require 'thor'
class Dvcs  < Thor
  desc "init","Create an empty repository"
  def init
    puts "this is init function"
  end

  desc "add FILE_NAME","Add specific files that you want to track"
  def add(file_name)
    puts "this is add function file name is #{file_name}"
  end
  
  desc "clone PATH_URL","copy an existing repository"
  def clone(path_url)
    puts "this is clone function the path or url is #{path_url}"
  end

  desc "remove PATH","Remove specific files from the tracking list"
  def remove(path)
    puts "this is remove function the path is #{path}"
  end

  desc "status","Check the current status of the current repository"
  def status
    puts "this is status function"
  end

  desc "heads","Show the current heads"
  def heads
    puts "this is heads function"
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
    puts "this is commit function the comment is #{update_comment}"
  end

  desc "log [<options>] [<revision range>] [[--] <path>…]","View the changelog"
  def log(options,range,path)
    puts "this is log function the option is #{options} the range is #{range} the path is #{path}"
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
Dvcs.start()