require_relative '../FileProcessorModule/file_system'

module Clone
    extend FileSystem
    extend Init
    def Clone.create_repository(local_path, remote_path)
      #puts local_path+"/.dvcs"
     # puts remote_path+"/.dvcs"
      if ! Clone.check_folder_contents(local_path+"/.dvcs")
        puts "Repository already exist in current folder"
      elsif Clone.check_file_exists(remote_path+"/.dvcs/index")
        Clone.copy_complete_folder(remote_path+"/.",local_path)
        puts "Clone remote repository success"
      else
        puts "Remote folder is not a repository"
      end
    end
end
