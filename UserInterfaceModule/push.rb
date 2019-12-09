require_relative '../DataStructureModule/wrapper'
require_relative '../FileProcessorModule/file_system'

module Push
  def Push.push_return_back(remote_location)
  	local_head = DataStructure.getHEAD()
  	#todo: DataStructure.get_remote_version()
  	remote_head = DataStructure.get_remote_version()
  	if (local_head == remote_head) {
  		puts "The remote repository is the latest version."
  	} else {
  		puts Merge.merge_return_back(local_head, remote_head)
  	}
  end
 end