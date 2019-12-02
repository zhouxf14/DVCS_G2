require_relative '../DataStructureModule/wrapper'

module Cat
  def Cat.inspect(filename, version_id=:options)
  	if (version_id) {
  		puts DataStructure.search_commit(filename, HEAD)
  	} else {
  		puts DataStructure.search_commit(filename, version_id)
  	}
  end
end
