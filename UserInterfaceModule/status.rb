require_relative 'DataStructureModule/wrapper'
require File.expand_path('../file_system', __FILE__)
module Status
  extend FileSystem
  def Status.check()
    puts DataStructure.status
  end
end
