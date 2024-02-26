--v1

local function create_dir(path)
    if not fs.exists(path) then
        fs.makeDir(path)
    end
end

local function create_file(path)
    fs.open(path, "a").close()
end

local function forceGet(source, target)
    if fs.exists(target) then
        fs.delete(target)
    end
    
    shell.run("wget", source, target)
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
 
-- Add the folder to shell path
shell.setPath(shell.path()..":/progs")

-- Get git
forceGet("https://raw.githubusercontent.com/dfAndrade/cc-repo/main/git_utils.lua", "/progs/git")

-- Get JSON capabilities
forceGet("https://raw.githubusercontent.com/dfAndrade/cc-repo/main/utils/json.lua", "/libs/lua/json.lua")

-- Set git state
shell.run("git", "status", "dfAndrade", "cc-repo", "main")

-- Get startup file
shell.run("git", "get", "FredCarvalhoOliveira", "minecraft-cc-turtles", "master", "lua/startup.lua", "startup")

-- Get python from server
-- Success: "> Downloaded as progs/py"
-- Failure: "> Connecting to ... Failed"
forceGet("http://127.0.0.1:8080/", "progs/py")

-- Reset
shell.run("reboot")
