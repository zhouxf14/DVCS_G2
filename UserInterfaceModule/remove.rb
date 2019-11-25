require_relative '../DataStructureModule/wrapper'
require_relative '../FileProcessorModule/file_system'
module Remove
  extend FileSystem
  def Remove.remove_file(file_name,path)
    if (Add.check_file_exists(path+'/'+file_name))
        puts "File still exists in workspace"
        puts DataStructure.remove(file_name)
    else
        puts "File does not exist in workspace"
        puts DataStructure.remove(file_name)
    end
  end
end
