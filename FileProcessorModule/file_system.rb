
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

  ######################################################################################
  # Having the 4 functions below will make more sense when we get compression in place #
  ######################################################################################

  # Makes an "archived" copy at the specified location
  def store(old_path, new_path)
    IO.copy_stream(old_path, new_path)
  end

  # Takes an "archived" file and "unarchives" it at the specified location
  def restore(old_path, new_path)
    IO.copy_stream(old_path, new_path)
  end

  # Takes an "archived" file and "unarchives" it, returning the contents
  def retrieve(path)
    return File.read(path, 1073741824) || "" #Only reads a Gigabyte
  end

  # Returns the contents of a file that hasn't been archived
  def read(path)
    return File.read(path, 1073741824) || "" #Only reads a Gigabyte
  end

  def list_contents(folder)
    Dir.children(folder)
  end
  
  def remove_file(path)
    if(File.exist?(path))
      if(File.delete(path))
        true
      else
        false
      end
    else
      false
    end
  end
  
  def remove_folder(path)
    if(Dir.exist? (path))
      if(Dir.delete(path))
        true
      else
        false
      end
    else
      false
    end
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
  def get_remote_repo(url,local_name)
    begin
      open("#{url}") do |url|
        File.open("#{local_name}", "wb") do |file|
          file.write(url.read)
          True
        end
      end
    rescue
      False
    end
  end

  #This funciton is call system command provided by linux to compare the two different file.
  def compare_files(file1,file2)
    compare_result=`diff #{file1} #{file2} | cat -n` 
    if compare_result.length > 0
      return compare_result
    elsif compare_result.length == 0
      return nil
    end
  end

  #This function is call system command provided by linux to acquire all files(include the files in subfolder) in current file.
  def get_all_files_name()
  # file_list=` find "$(pwd)" -type f -not -path "$(pwd)/.dvcs/*" ` # absolute path version
    file_list=` find  -type f -not -path "./.dvcs/*" `
    return file_list
  end
end

def remove_dir(path)
  if Dir.empty?(path)
    puts "empty"
    Dir.rmdir(path)
  else
    Dir.each_child(path) do |child|
      if child == '.DS_Store'
        puts "found ds store"
      else
        puts "nope"
        if File.file?(child)
          File.delete(child)
        else
          remove_dir(child)
        end
      end
    end
  end
end
