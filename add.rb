require_relative 'DataStructureModule/wrapper'
require File.expand_path('../file_system', __FILE__)
module Add
  extend FileSystem
  def Add.add_file(file_name,path)
    if (Add.check_file_exists(path+'/'+file_name))
      puts DataStructure.add(file_name)
    else
      puts "Error the file not exist"
    end
  end

end
