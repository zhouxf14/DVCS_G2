require_relative '../DataStructureModule/wrapper'
require_relative '../FileProcessorModule/file_system'

module Cat
extend FileSystem
  def Cat.inspect(filename, version_id)
	if DataStructure.search_commited(version_id)
		file_path=DataStructure.search_commited_file(filename, version_id)
		if file_path.nil?
			puts filename + " is not exist in version: "+ version_id
		else
			Cat.read_lines(file_path){|line| puts line}
		end
	else
		puts "The version not exist"
	end
  end
end
