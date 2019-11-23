require_relative '../DataStructureModule/wrapper'
require_relative '../FileProcessorModule/file_system'
module Status
  def Status.check()
    puts DataStructure.status
  end
end
