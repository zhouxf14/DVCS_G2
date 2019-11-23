require_relative 'DataStructureModule/wrapper'
require File.expand_path('../file_system', __FILE__)
module Remove
  extend FileSystem
  def Remove.remove_file(file_name,path)
    if (Add.check_file_exists(path+'/'+file_name))
        puts "File still exist in Workspace" 
        puts DataStructure.remove(file_name)
    else
        puts "File not exist in Workspace" 
        puts DataStructure.remove(file_name)
    end
  end
end
