local file = require "file"
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
    [pos.NORTH] = { 0, 0, -1 },
    [pos.SOUTH] = { 0, 0, 1 },
    [pos.EAST]  = { 1, 0, 0 },
    [pos.WEST]  = { -1, 0, 0 },
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

function pos.loadPosition()
    file.createIfNotExists(POS_PATH)
    local f = fs.open(POS_PATH, "r")
    local raw_content = f.readAll()
    f.close()
    local posinfo = textutils.unserialize(raw_content)

    position = vector.new(posinfo.position or position)
    direction = posinfo.direction or direction
end

function pos.savePosition()
    file.createIfNotExists(POS_PATH)
    local f = fs.open(POS_PATH, "w")

    local state = {
        position = position,
        direction = direction
    }

    f.write(textutils.serialise(state))
    f.close()
end

function pos.move(fwd_bwd)
    if fwd_bwd ~= pos.FORWARD and fwd_bwd ~= pos.BACK then
        error("Invalid movement direction | [pos.FORWARD | pos.BACK]")
    end

    local toMove = dir_map[direction]
    if fwd_bwd == pos.BACK then
        toMove:mul(-1)
    end

    position = position:add(toMove)

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
