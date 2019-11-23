require_relative '../FileProcessorModule/file_system'

module Clone
    extend FileSystem
    extend Init
    def Clone.create_repository(local_path, remote_path)
        if (Init.build_repo_structure(local_path))
            if (FileSystem.get_remote_repo(remote_path))
              puts "Succeeded"
            else
              puts "Failed"
            end
        else
          puts "Failed"
        end
    end
end
