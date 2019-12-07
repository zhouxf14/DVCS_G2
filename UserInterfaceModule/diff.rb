require_relative '../DataStructureModule/wrapper'
require_relative '../FileProcessorModule/file_system'

module Diff
  extend FileSystem
  def Diff.diff_version(version1,version2)
    #step 1 : check both version1 exist
    #step 2 : compare all the file and show the difference
    if version2==nil and version1=="HEAD"
      diff_result=DataStructure.diff(DataStructure.getHEAD())
      diff_result.each{|item| 
        #['hi'].cycle(3)
        #max = a > b ? a : b
        if item["new_file_indicate"].nil?
          v1_str="|-Version "+item["version1"]+" File name: "+item["file1"]+ " line cursor: <"
          v2_str="|-Version "+"repository"+" File name: "+item["file2"]+ " line cursor: >"
          max_len= v1_str.length > v2_str.length ? v1_str.length : v2_str.length
          p_lin="_"*(max_len)
          puts p_lin
          puts v1_str
          puts v2_str
          puts " "
          puts item["diff_result"]
          puts p_lin
          puts " "
          puts " "
        else
          ver=item["new_file_indicate"]
          v_str="|-Version "+item[ver]+" File name: "+item["file1"]+ " has not been committed"
          p_lin="_"*(v_str.length)
          puts p_lin
          puts v_str
          puts p_lin
          puts " "
          puts " "
        end
      }
    elsif version2==nil and version1.casecmp("HEAD")==-1
      diff_result=DataStructure.diff(version1)
      diff_result.each{|item| 
        #['hi'].cycle(3)
        #max = a > b ? a : b
        if item["new_file_indicate"].nil?
          v1_str="|-Version "+item["version1"]+" File name: "+item["file1"]+ " line cursor: <"
          v2_str="|-Version "+item["version2"][0,8]+" File name: "+item["file2"]+ " line cursor: >"
          max_len= v1_str.length > v2_str.length ? v1_str.length : v2_str.length
          p_lin="_"*(max_len)
          puts p_lin
          puts v1_str
          puts v2_str
          puts " "
          puts item["diff_result"]
          puts p_lin
          puts " "
          puts " "
        else
          ver=item["new_file_indicate"]
          v_str="|-Version "+item[ver][0,8]+" File name: "+item["file1"]+ " has not been committed"
          p_lin="_"*(v_str.length)
          puts p_lin
          puts v_str
          puts p_lin
          puts " "
          puts " "
        end
      }
    elsif version2 !=nil and version1.casecmp("HEAD")==-1
      diff_result=DataStructure.diff(version1,version2)
      diff_result.each{|item| 
        if item["new_file_indicate"].nil?
          v1_str="|-Version "+item["version1"][0,8]+" File name: "+item["file1"]+ " line cursor: <"
          v2_str="|-Version "+item["version2"][0,8]+" File name: "+item["file2"]+ " line cursor: >"
          max_len= v1_str.length > v2_str.length ? v1_str.length : v2_str.length
          p_lin="_"*(max_len)
          puts p_lin
          puts v1_str
          puts v2_str
          puts " "
          puts item["diff_result"]
          puts p_lin
          puts " "
          puts " "
        else
          ver=item["new_file_indicate"]
          v_str="|-Version "+item[ver][0,8]+" File name: "+item["file1"]+ " new file!"
          p_lin="_"*(v_str.length)
          puts p_lin
          puts v_str
          puts p_lin
          puts " "
          puts " "
        end
      }
    end
  end

end
