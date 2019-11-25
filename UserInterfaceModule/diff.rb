require_relative '../DataStructureModule/wrapper'
require_relative '../FileProcessorModule/file_system'

module Diff
  extend FileSystem
  def Diff.diff_version(version1,version2)
    #step 1 : check both version1 exist
    #step 2 : compare all the file and show the difference
    DataStructure.diff(version1,version2)
  end

end
