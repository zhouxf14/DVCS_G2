require_relative '../DataStructureModule/wrapper'
require_relative '../FileProcessorModule/file_system'

module Pull
  def Pull.pull_return_back(remote_location)
  	local_head = DataStructure.getHEAD()
  	local_status = DataStructure.status
  	if (local_status.include? "Not Committed" || local_status.include? "Uncommitted Changes" || local_status.include? "Deleted") {
  		FileSystem.get_remote_repo(remote_location, local_new_path)
  		#todo: where to download this temporary version in order to get its version id?
  		remote_head = DataStructure.getHEAD()
  		puts Merge.merge_return_back(local_head, remote_head)
  	} else {
  		FileSystem.get_remote_repo(remote_location, Dir.pwd)
  		if (local_head == DataStructure.getHEAD()) {
  			puts "It's already the latest version"
  		} else {
  			puts "The latest version has been pulled successfully"
  		}
  	}
  end
 end
