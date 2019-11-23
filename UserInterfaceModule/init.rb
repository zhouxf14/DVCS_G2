require_relative '../FileProcessorModule/file_system'

module Init
    extend FileSystem
    def Init.create_repository(local_path)
        if (build_repo_structure(local_path))
            puts "Init repository success"
        end
    end
    def Init.build_repo_structure(local_path)
        #if there isn't a dvcs folder
        dvcspath=local_path+'/.dvcs'
        if Init.check_folder_contents(".dvcs")
          #build and enter the dvcs folder
          if (Init.new_folder(".dvcs") and  system ("cd "+dvcspath))
            #build folders inside the dvcs folder
            if (Init.new_folder(dvcspath+"/info") &&
                Init.new_folder(dvcspath+"/objects") &&
                Init.new_folder(dvcspath+"/refs") &&
                Init.new_folder(dvcspath+"/objects/commits") &&
                Init.new_folder(dvcspath+"/objects/archives") &&
                Init.new_file(dvcspath+"/refs/master","null") &&
                Init.new_file(dvcspath+"/info/branch","master")
            )
              #build files inside the dvcs folder
              if (Init.new_file(dvcspath+"/config") and Init.new_file(dvcspath+"/description") and Init.new_file(dvcspath+"/HEAD", "null") and Init.new_file(dvcspath+"/index"))
                #build sub-folders temp and repository inside objects folder
                if ( Init.new_folder(dvcspath+"/objects/temp") and Init.new_folder(dvcspath+"/objects/repository"))
                  #escape back outside of dvcs folder to working directory
                  system("cd ..")
                  system("cd ..")
                  #return success- all other return cases are for errors.
                  true
                else
                  puts("error building folders")
                  false
                end
              else
                puts("error building files")
                false
              end
            else
              puts("error building folders")
              false
            end
          else
            puts("error building dvcs folder")
            false
          end
        else
          puts("Error: dvcs folder already exists")
          false
        end
      end
end
