require_relative '../DataStructureModule/wrapper'
require_relative '../FileProcessorModule/file_system'
# Thor calls UI.Merge
# UI.Merge calls DS function to find the common ancestor between the two given branches. 
# For each file in the provided branches, UI.Merge calls DS function to find the diff between the two versions of the files, and the DS function outputs a file with all added and removed material. 
# If there are conflicts, the DS function uses a conflict resolution algorithm
# UI.Merge outputs whether or not the merge is successful

module Merge
  def Merge.merge_return_back(branch_1, branch_2)
    
    if DataStructure.search_commited(branch_1) and DataStructure.search_commited(branch_1)
      diff_result=DataStructure.diff(branch_1,branch_2)
      merge_info=[]
      diff_result.each{ |item|
        compare_info={"new_file_indicate"=>nil,"include_indicate"=>nil,"same_indicate"=>nil,"conflict_indicate"=>nil,"file_name"=>nil,"file_path"=>nil,"file_name_c"=>nil,"file_path_c1"=>nil,"file_path_c2"=>nil}
        if item["new_file_indicate"].nil?

          if item["diff_result"].include? "<" and not item["diff_result"].include? ">"
            p item["version1"][0,8]+" contain version" +item["version2"][0,8]
            p "Only exist <"
            puts item["diff_result"]
            puts "------------------------------------------------------------------------"
            compare_info["include_indicate"]=true
            compare_info["file_name"]=item["file1"]
            compare_info["file_path"]=item["file1_path"]


          elsif not item["diff_result"].include? "<" and item["diff_result"].include? ">"
            p item["version2"][0,8]+" contain version" +item["version1"][0,8]
            p "Only exist >"
            puts item["diff_result"]
            puts "------------------------------------------------------------------------"
            compare_info["include_indicate"]=true
            compare_info["file_name"]=item["file2"]
            compare_info["file_path"]=item["file2_path"]

          elsif item["diff_result"].include? "<" and item["diff_result"].include? ">"
            p item["version1"][0,8]+" conflict" +item["version2"][0,8]
            p "Exist < and >"
            puts item["diff_result"]
            puts "------------------------------------------------------------------------"
            compare_info["conflict_indicate"]=true
            compare_info["file_name_c"]=item["file1"]
            compare_info["file_path_c1"]=item["file1_path"]
            compare_info["file_path_c2"]=item["file2_path"]
            
          elsif not item["diff_result"].include? "<" and not item["diff_result"].include? ">" and item["diff_result"]=="The are same"
            p item["version1"][0,8]+" same as " +item["version2"][0,8]
            p "Exist nothing"
            puts item["diff_result"]
            puts "------------------------------------------------------------------------"
            compare_info["same_indicate"]=true
            compare_info["file_name"]=item["file1"]
            compare_info["file_path"]=item["file1_path"]
            
          end
        else
          puts "------------------------------------------------------------------------"
          ver=item["new_file_indicate"]
          p item[ver]
          p item["file1"]
          p item["file1_path"]
          compare_info["new_file_indicate"]=true
          compare_info["file_name"]=item["file1"]
          compare_info["file_path"]=item["file1_path"]
          
        end
        merge_info.push(compare_info)
      }
      merge_info.each{|item| p item}
    else
      puts "Branch not exist"
    end
  end
end