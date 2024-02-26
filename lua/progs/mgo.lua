local move = require ".libs.lua.turtle.move"

local tArgs = { ... }


local function main()
    local init_dir = move.position.getDirection()
    local left = move.position.getLeft(init_dir)
    local right = move.position.getRight(init_dir)

    for _, v in ipairs(tArgs) do
        if v == "fwd" then
            move.turnTo(init_dir)
            move.fwd()
        elseif v == "back" then
            move.turnTo(init_dir)
            move.back()
        elseif v == "left" then
            move.turnTo(left)
            move.fwd()
        elseif v == "right" then
            move.turnTo(right)
            move.fwd()
        elseif v == "up" then
            move.moveUp()
        elseif v == "down" then
            move.moveDown()
        end
    end
end

if pcall(main) then
    -- no errors while running `foo'
    print("Success")
else
    -- `foo' raised an error: take appropriate actions
    print("Error")
end

-- always do this :D
move.position.savePosition()
