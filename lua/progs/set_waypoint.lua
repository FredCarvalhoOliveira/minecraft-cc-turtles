local waypoints = require ".libs.lua.turtle.waypoints"
local argparse = require ".libs.lua.argparse"


local parser = argparse("set_waypoint ", "Work with waypoints")

-- Conf comand
-- parser:command_target "option"

-- Conf set
local set = parser:command "set"
set:argument("type"):choices({ "chest", "dump", "home", "fuel" })
set:argument("coords", "X Y Z coords"):args(3)
set:action(function(args)
    print(textutils.serialise(args))
    -- type
    -- x,y,z
    -- waypoints.set()
end)

-- Conf list
parser:command "list"
parser:action(function(args)
    print(textutils.serialise(args))
    local list = waypoints.list()
    textutils.serialise(list)
end)

parser:parse({...})