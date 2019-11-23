require File.expand_path('../file_system', __FILE__)
module Clone
    extend FileSystem
    extend Init
    def Clone.create_repository(local_path)
        if (Init.build_repo_structure(local_path))
            if (FileSystem.get_remote_repo(local_path))
              puts "Succeeded"
            else
              puts "Failed"
            end
        else
          puts "Failed"
        end
    end
end
