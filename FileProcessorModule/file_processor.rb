module FP

  #init folder:
  #
  #creates a folder containing:
  #config file
  #

  def new_folder(folder_name)
    if (system("mkdir #{folder_name}") and system("cd #{folder_name}") and system("cd .."))
      true
    else
      puts("Error building folder #{folder_name}")
      false
    end
  end

  def new_file(filename)
    if (system("touch #{filename}"))
      true
    else
      puts("Error building file #{filename}")
      false
    end
  end

  def append_text(text,filename)
    if (system("\"#{text}\" >> #{filename}"))
      true
    else
      puts("Error appending text to #{filename}")
      false
    end
  end

  #check whether or not folder 'query' exists in the current directory
  def check_folder_contents(query)
    if (system("[ -d #{query} ]"))
      puts("Error in current directory: #{query} already exists.")
      false
    else
      true
    end
  end

  def check_file_exists(query)
    if (system("[ -e #{query}]"))
      true
    else
      false
    end
  end

  #once we know that we can init files and folders, build the repo with empty folders and blank files.
  def build_repo_structure()
    #if there isn't a dvcs folder
    if check_folder_contents("dvcs")
      #build and enter the dvcs folder
      if (new_folder("dvcs") and system("cd dvcs"))
        #build folders inside the dvcs folder
        if (new_folder("hooks") and new_folder("info") and new_folder("objects") and new_folder("refs"))
          #build files inside the dvcs folder
          if (new_file("config") and new_file("description") and new_file("HEAD") and new_file("index"))
            #if everything works, navigate back out, and return success.
            system("cd ..")
            true
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