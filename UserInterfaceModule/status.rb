require_relative 'DataStructureModule/wrapper'
require_relative 'FileSystemModule/file_system'
module Status
  def Status.check()
    puts DataStructure.status
  end
end