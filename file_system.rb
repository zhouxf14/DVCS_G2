module FileSystem

  #init folder:
  #
  #creates a folder containing:
  #config file
  #

  def new_folder(folder_name)
    if (system("mkdir #{folder_name}"))
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
  
  def read_lines(file_name)
    File.open("#{file_name}") do |file|
      file.each_line do |line|
        yield(line)
      end
    end
  end

end
