require_relative '../DataStructureModule/wrapper'
require_relative '../FileProcessorModule/file_system'

module Merge
  def Merge.return_back(branch_1, branch_2)
   
# Thor calls UI.Merge
# UI.Merge calls DS function to find the common ancestor between the two given branches. 
# For each file in the provided branches, UI.Merge calls DS function to find the diff between the two versions of the files, and the DS function outputs a file with all added and removed material. 
# If there are conflicts, the DS function uses a conflict resolution algorithm
# UI.Merge outputs whether or not the merge is successful

  end
end