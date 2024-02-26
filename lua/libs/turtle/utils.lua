local utils = {}

-- Will canibalize any of the inventory for fuel
function utils.refuelFromInv(target)
    target = target or 200

    -- Early check
    if turtle.getFuelLevel() >= target then
        return true
    end

    -- Check inventory
    for i = 1, 16 do
        -- Go through the inventory
        turtle.select(i)

        -- If this slot has a fuel source
        if turtle.refuel(0) then
            -- Try to refuel until target is reched or items end
            while turtle.getFuelLevel() < target and turtle.getItemCount() > 0 do
                turtle.refuel(1)
            end

            -- If goal is reached exit
            if turtle.getFuelLevel() >= target then
                return true
            end
        end
    end

    return false
end





return utils
