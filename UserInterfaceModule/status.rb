require_relative '../DataStructureModule/wrapper'
require_relative '../FileProcessorModule/file_system'
module Status
  extend FileSystem
  def Status.check()
    new_file_list=[]
    workspace_file_list=Status.get_all_files_name().split(/\n/)
    repository_file_list=DataStructure.repository_file_list(DataStructure.getHEAD())
    stage_file_status=DataStructure.status
    workspace_file_list.each{ |line|
      len=line.length
      filename=line[2,len]
      if repository_file_list.key?(filename) or stage_file_status.key?(filename)

      else
        new_file_list.push(filename)
      end
    }
    if new_file_list.length>0
      puts "New files untracked"
      puts new_file_list
      puts "----------------------------"
    
    end
    puts stage_file_status
    
  end
end
