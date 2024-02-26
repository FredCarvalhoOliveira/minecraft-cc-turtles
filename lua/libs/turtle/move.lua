local pos = require ".libs.lua.turtle.position"
local move = {}

pos.loadPosition()

local function tryMoveH(fwd_bwd)
    local s, r
    if fwd_bwd then
        s, r = turtle.forward()
    else
        s, r = turtle.back()
    end

    if not s then
        return { false, r }
    end

    pos.move(fwd_bwd)

    return { true }
end

local function tryMoveV(up_down)
    local s, r
    if up_down then
        s, r = turtle.up()
    else
        s, r = turtle.down()
    end

    if not s then
        return { false, r }
    end

    if up_down then
        pos.moveUp()
    else
        pos.moveDown()
    end

    return { true }
end

function move.fwd()
    return tryMoveH(true)
end

function move.back()
    return tryMoveH(true)
end

function move.up()
    return tryMoveV(true)
end

function move.down()
    return tryMoveV(false)
end

function move.turnRight()
    turtle.turnRight()
    pos.turnRight()
end

function move.turnLeft()
    turtle.turnLeft()
    pos.turnLeft()
end

function move.turnTo(dir)
    while pos.getDirection() ~= dir do
        move.turnLeft()
    end
end

move.position = pos

return move
