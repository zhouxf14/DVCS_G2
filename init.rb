require File.expand_path('../file_system', __FILE__)
module Init
    extend FileSystem
    def Init.creat_repository(local_path)
        if (Init.build_repo_structure())
            puts "Init repository success"
        end
    end
end