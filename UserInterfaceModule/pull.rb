require_relative '../DataStructureModule/wrapper'
require_relative '../FileProcessorModule/file_system'

module Pull
  def Pull.pull_return_back(remote_location)
  	local_head = DataStructure.getHEAD()
  	#todo: DataStructure.get_remote_version()
  	remote_head = DataStructure.get_remote_version()
  	local_status = DataStructure.status
  	if local_status.include? "Not Committed" or local_status.include? "Uncommitted Changes" or local_status.include? "Deleted" 
  		puts Merge.merge_return_back(local_head, remote_head)
  		#todo: how to deal with the uncommitted changes?
	elsif local_head == remote_head
  			puts "It's already the latest version"
  	else
  			puts Merge.merge_return_back(local_head, remote_head)
  			puts "The latest version has been pulled successfully"
	end
  end
 end
