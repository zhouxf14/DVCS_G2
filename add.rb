module Add
  extend FileSystem
  def Add.add_file(file_name)
    dvcspath = local_path+'/.dvcs'
    if(Add.append_text("#{file_name}\n",dvcspath + "/index"))
      True
    else
      puts "error appending to file"
      False
    end
  end

end
