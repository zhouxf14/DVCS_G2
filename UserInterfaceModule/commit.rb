require_relative '../DataStructureModule/wrapper'
require_relative '../FileProcessorModule/file_system'

module Commit
  extend FileSystem
  def Commit.commit_stage(update_comment)
    if (update_comment.length > 0 and update_comment.length < 20)
        DataStructure.commit update_comment
    else
      puts "Update comments can not be emputy or more than 20 characters"
    end
  end

end
