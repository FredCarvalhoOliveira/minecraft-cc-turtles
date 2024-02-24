function create_dir(path)
    if not fs.exists(path) then
        fs.makeDir(path)
    end
end

function create_file_rel(path)
    fs.open(shell.resolve(path), "a").close()
end

function create_file(path)
    fs.open(path, "a").close()
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

--Create .git
create_dir(".git")
create_file("/.git/state")
 
-- Our program libraries
create_dir("libs")
create_dir("libs/lua")
create_dir("libs/python")
 
-- Move git into progs  
forceCopy("/disk/git", "/progs/git")
 
-- Add the folder to shell path
shell.setPath(shell.path()..":/progs")
 
-- Get JSON capabilities
shell.run("git", "get", "dfAndrade", "cc-repo", "main", "utils/json.lua", "/libs/lua/json.lua")

-- Get git "pull" capabilities
shell.run("git", "get", "dfAndrade", "cc-repo", "main", "git_utils.lua", "/progs/git_utils")

-- Get startup file
shell.run("git", "get", "FredCarvalhoOliveira", "minecraft-cc-turtles", "master", "lua/startup.lua", "startup")

-- Get python from server
-- Success: "> Downloaded as progs/py"
-- Failure: "> Connecting to ... Failed"
shell.run("wget", "http://127.0.0.1:8080/", "progs/py")
