--v6

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

-- Better term
forceGet("https://raw.githubusercontent.com/SquidDev-CC/mbs/master/mbs.lua", "mbs")

-- Pull progs 
shell.run("git", "status", "FredCarvalhoOliveira", "minecraft-cc-turtles", "master")
shell.setDir("/libs/lua")
shell.run("git", "pull", "lua/libs")
shell.setDir("/progs")
shell.run("git", "pull", "lua/progs")
shell.setDir("/")
shell.run("git", "get", "src/mining.py", "mining.py")

-- repo switchers
forceGet("https://raw.githubusercontent.com/FredCarvalhoOliveira/minecraft-cc-turtles/master/lua/progs/df_git.lua", "/progs/df_git.lua")
forceGet("https://raw.githubusercontent.com/FredCarvalhoOliveira/minecraft-cc-turtles/master/lua/progs/fr_git.lua", "/progs/fr_git.lua")

-- Set git state
shell.run("git", "status", "dfAndrade", "cc-repo", "main")

-- Get startup file
shell.run("git", "get", "FredCarvalhoOliveira", "minecraft-cc-turtles", "master", "lua/startup.lua", "startup")



-- Get python from server
-- Success: "> Downloaded as progs/py"
-- Failure: "> Connecting to ... Failed"
forceGet("http://127.0.0.1:8080/", "progs/py")

-- Install better shell
shell.run("mbs", "install")

-- Reset
shell.run("reboot")
