require_relative '../DataStructureModule/wrapper'
require_relative '../FileProcessorModule/file_system'

module Diff
  extend FileSystem
  def Diff.diff_version(version1,version2)
    #step 1 : check both version1 exist
    #step 2 : compare all the file and show the difference
    if version2==nil and version1=="HEAD"
      DataStructure.diff(DataStructure.getHEAD())
    elsif version2==nil and version1.casecmp("HEAD")==-1
      DataStructure.diff(version1)
    elsif version2 !=nil and version1.casecmp("HEAD")==-1
      DataStructure.diff(version1,version2)
    end
  end

end
