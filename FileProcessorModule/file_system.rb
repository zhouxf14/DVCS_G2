
module FileSystem

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
    return !(Dir.exist? query)
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
    return $_.chomp("\n")
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

  def list_contents(folder)
    Dir.children(folder)
  end
  
  def remove_file(path)
    if(File.exist?(path))
      if(File.delete(path))
        True
      else
        False
      end
    else
      False
    end
  end
  
  def remove_folder(path)
    if(Dir.exist? (path))
      if(Dir.delete(path))
        True
      else
        False
      end
    else
      False
    end# lost a end
  end
    
  #removes a line specified by its text, or any substring of that text (careful!)
  #note that this temporarily creates a file named _.txt, which I figure is one of the least
  #likely possible names for a file, however feel free to change that if you so desire. This is untested
  #on files other than files that started out as .txt, but I don't see why it shouldn't work.
  def remove_line(file_path, text)
    out = File.new('_.txt','w+')
    i = 0
    File.open(file_path, 'r+') do |file|
      file.each_line do |line|
        if line.chomp.eql? text
          #do nothing
          i += 1
        else
          out.write line
        end
      end
    end
    File.rename('_.txt', file_path)
    return i > 0
  end
    
  #changes a line containing 'text' to contain 'new_text' instead. Note that the entire line containing 'text' is
  #changed to contain exactly 'new_text', so this function cannot be used as a find and replace in the purest sense.
  #Also, like remove_line, this function also uses _.txt, which, again is changeable if need be.
  def edit_line(file_path, text, new_text)
    out = File.new('_.txt','w+')
    File.open(file_path, 'r+') do |file|
      file.each_line do |line|
        if line.include? text
          out.write new_text
          out.write "\n"
        else
          out.write line
        end
      end
    end
    File.rename('_.txt', file_path)
  end
  
  #downloads a remote file at 'url' and places it at 'local name'. Returns true if success, i.e. url is valid and the file
  #could be opened. Else returns false. It should work on folders too, if it doesn't, let me know and I'll go fix it.
  def download_remote(url,local_name)
    begin
      open("#{url}") do |url|
        File.open("#{local_name}", "wb") do |file|
          file.write(url.read)
          TRUE
        end
      end
    rescue
      FALSE
    end
  end

end
