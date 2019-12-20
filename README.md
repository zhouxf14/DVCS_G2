# 453_DVCS

### Install
```
1.Download the code
2.Make sure your ruby gem installs the Thor package. If not, please run the command: gem install thor
3.Upload the files to cycle2 server (recommended) under PATH
4.Open the terminal in the directory where you want to set a workspace.
5.Run command "ruby PATH/dvcs.rb COMMAND PARAMETER"  in your workspace:
    eg: ruby PATH/dvcs.rb add file1
    Tips: The PATH is the path where the folder you install the dvcs.
Note: our system runs in Linux
```
### Running Examples:
```
        ruby PATH/dvcs.rb init
        ruby PATH/dvcs.rb add <file>
        ruby PATH/dvcs.rb remove <file>
        ruby PATH/dvcs.rb status
        ruby PATH/dvcs.rb clone <path> # The path should be a repository folder path and current folder should not be a repository
        ruby PATH/dvcs.rb commit <message>
        ruby PATH/dvcs.rb head
        ruby PATH/dvcs.rb log     #show the version id 
        ruby PATH/dvcs.rb diff <version_id_1> <version_id_2>  or ruby PATH/dvcs.rb diff HEAD
        ruby PATH/dvcs.rb merge <version_id_1> <version_id_2> 
        ruby PATH/dvcs.rb cat <file> <version_id> 
        ruby PATH/dvcs.rb checkout <version_id>
```