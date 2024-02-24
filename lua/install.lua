function create_dir(path)
    if not fs.exists(path) then
        fs.makeDir(path)
    end
end
 
function forceCopy(source, target)
    if fs.exists(target) then
        fs.delete(target)
    end
    
    fs.copy(source, target)
end
 
-- Create your own "rom" folder
-- that will be added to PATH
create_dir("progs")
 
-- Our program libraries
create_dir("libs")
 
-- move json lib
forceCopy("/disk/json.lua", "libs/json.lua")
 
-- Move git into progs  
forceCopy("/disk/git", "/progs/git")
 
-- Add the folder to shell path
-- shell.setPath(shell.path()..":/myProgs")
 
-- Retrieve git "pull" capabilities
shell.run("git", "get", "dfAndrade", "cc-repo", "main", "git_utils.lua", "/myProgs/git_utils.lua")
 
-- TODO Pull init packages by pulling specific folder
