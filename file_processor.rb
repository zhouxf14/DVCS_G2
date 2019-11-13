module FP

  #init folder:
  #
  #creates a folder containing:
  #config file
  #

  def new_folder(folder_name):
    if (system("mkdir #{folder_name}") and system("cd #{folder_name}") and system("cd ..")):
      True
    else:
      print("Error building folder #{folder_name}")
      False
    end
  end

  def new_file(filename):
    if (system("touch #{filename}")):
      True
    else:
      print("Error building file #{filename}")
      False
    end
  end

  def append_text(text,filename)
    if (system("\"#{text}\" >> #{filename}")):
      True
    else:
      print("Error appendint text to #{filename}")
      False
    end
  end

  #check whether or not folder 'query' exists in the current directory
  def check_folder_contents(query):
    if (system("[ -d #{query} ]")):
      print("Error in current directory: #{query} already exists.")
      False
    else:
      True
    end
  end

  #once we know that we can init files and folders, build the repo with empty folders and blank files.
  def build_repo_structure():
    new_folder("hooks")
    new_folder("info")
    new_folder("objects")
    new_folder("refs")
    new_file("config")
    new_file("description")
    new_file("HEAD")
    new_file("index")
  end



end
