local waypoints = require ".libs.lua.turtle.waypoints"
local argparse = require ".libs.lua.argparse"

-- Create Parser
local parser = argparse("set_waypoint ", "Work with waypoints")

-- Conf set
local set = parser:command "set"
set:argument("type"):choices({ "chest", "dump", "home", "fuel" })
set:argument("x", "X coord")
set:argument("y", "Y coord")
set:argument("z", "Z coord")
set:action(function(args)
    print(textutils.serialise(args))
    waypoints.set(args.type, args.x, args.y, args.z)
end)

-- Conf remove
local remove = parser:command "remove"
remove:argument("type"):choices({ "chest", "dump", "home", "fuel" })
remove:action(function(args)
    print(textutils.serialise(args))
    waypoints.remove(args.type)
end)

-- Conf list
local list  = parser:command "list"
list:action(function()
    local w_list = waypoints.getAll()
    print(textutils.serialise(w_list))
end)

parser:parse({...})