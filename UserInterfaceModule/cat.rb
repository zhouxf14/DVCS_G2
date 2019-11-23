require_relative 'DataStructureModule/wrapper'

module Cat
  def Cat.inspect(file_path)
    puts DataStructure.search_commit(file_path) # DS.search_commit can search the file name in the commit file which is pointed by the version and output the list of data including version history, author(s)
  end
end