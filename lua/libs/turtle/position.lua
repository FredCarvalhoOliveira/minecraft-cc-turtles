local file = require ".libs.lua.file"
local pos = {}

local POS_PATH = "/.state/position"

pos.FORWARD = "fwd"
pos.BACK = "bwd"

-- Source https://minecraft.makecode.com/courses/csintro/coordinates/overview
pos.NORTH = "NORTH" -- -Z
pos.SOUTH = "SOUTH" -- +Z
pos.EAST = "EAST"   -- +X
pos.WEST = "WEST"   -- -X

local dir_map = {
    [pos.NORTH] = { x=0, y=0, z=-1 },
    [pos.SOUTH] = { x=0, y=0, z=1 },
    [pos.EAST]  = { x=1, y=0, z=0 },
    [pos.WEST]  = { x=-1, y=0, z=0 },
}

local right = {
    [pos.NORTH] = pos.EAST,
    [pos.EAST]  = pos.SOUTH,
    [pos.SOUTH] = pos.WEST,
    [pos.WEST]  = pos.NORTH,
}

local left = {
    [pos.NORTH] = pos.WEST,
    [pos.WEST]  = pos.SOUTH,
    [pos.SOUTH]  = pos.EAST,
    [pos.EAST] = pos.NORTH,
}

local position = vector.new(0, 0, 0)
local direction = pos.NORTH

-- Returns vectorized positon
function pos.getPosition()
    return position
end

function pos.getDirection()
    return direction
end

function pos.loadPosition()
    file.createIfNotExists(POS_PATH)
    local f = fs.open(POS_PATH, "r")
    local raw_content = f.readAll()
    f.close()
    local posinfo = textutils.unserialize(raw_content)

    print("From file: "..textutils.serialize(posinfo))
    posinfo = posinfo or {}

    print("After nil check: "..textutils.serialize(posinfo))

    if posinfo.position then
        position = vector.new( posinfo.position)
        print("To vector: "..textutils.serialize(position))
    end

    direction = posinfo.direction or direction
end

function pos.savePosition()
    file.createIfNotExists(POS_PATH)
    local f = fs.open(POS_PATH, "w")

    local state = {
        position = position,
        direction = direction
    }

    local serialized  = textutils.serialise(state)
    print("will save: "..serialized)

    f.write()
    f.close()
end

function pos.move(fwd_bwd)
    if fwd_bwd ~= pos.FORWARD and fwd_bwd ~= pos.BACK then
        error("Invalid movement direction | [pos.FORWARD | pos.BACK]")
    end

    print("")
    print("will move: "..fwd_bwd)
    local toMove = dir_map[direction]
    toMove = vector.new(toMove)
    print("to "..textutils.serialize(toMove))
    if fwd_bwd == pos.BACK then
        toMove:mul(-1)
    end

    print("to2 "..textutils.serialize(toMove))

    print("init pos: "..textutils.serialize(position))

    position = position:add(toMove)

    print("final pos: "..textutils.serialize(position))

    return position
end

function pos.moveUp()
    position = position:add(vector.new(0, 1, 0))
end

function pos.moveDown()
    position = position:add(vector.new(0, -1, 0))
end

function pos.turnRight()
    direction = right[direction]
end

function pos.turnLeft()
    direction = left[direction]
end

function pos.getLeft(dir)
    return left[dir]
end

function pos.getRight(dir)
    return right[dir]
end

return pos
