module FileSystem

  #init folder:
  #
  #creates a folder containing:
  #config file
  #

  def new_folder(folder_name)
    Dir.mkdir(folder_name)
  end

  def new_file(filename, text = "")
    File.open(filename, "w") { |file|
      file.write text
    }
  end

  def append_text(filename, text)
    File.open(filename, "a") { |file|
      file.write text
    }
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
    return File.exist? query
  end

  def read_lines(file_name)
    File.open(file_name) do |file|
      file.each_line do |line|
        yield(line.chomp("\n"))
      end
    end
  end

  def get_line(file_name, lineno)
    File.open(file_name) do |file|
      lineno.times{ file.gets }
    end
    return $_
  end
  
  #returns line number given text is found in, or -1 if it is not found.
  def search_file(text,file_name)
    line_num = 0
    file_name.read_lines do |line|
      if line.include? text
        return line_num
      end
      line_num += 1
    end
    return -1
  end

  def store(old_path, new_path)
    #File.open(new_path, "w") { |file|
    #  read_lines(old_path){|line|
    #    file.puts line
    #  }
    #}
    IO.copy_stream(old_path, new_path)
  end

  def retrieve(path)
    return File.read(path, 1073741824) || "" #Only reads a Gigabyte
  end

  def read(path)
    return File.read(path, 1073741824) || "" #Only reads a Gigabyte
  end

end
