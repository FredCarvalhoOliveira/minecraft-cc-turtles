-- Source https://pastebin.com/2Zf5an8H

COMPASS = { 'N', 'E', 'S', 'O' }

function SmartTurtle()
    local clsTurtle = {} -- the table representing the class, which will double as the metatable for any instances
    clsTurtle.__index = clsTurtle -- failed table lookups on the instances should fallback to the class table, to get methods
 
    local retSelf = setmetatable({}, clsTurtle)

    retSelf.x = 0
    retSelf.y = 0
    retSelf.z = 0
    retSelf.orientation = 0 -- N, or bi .-.

    -- logging variables
    retSelf.useLog = false
    retSelf.logFileName = ""
    retSelf.logFileExists = false
    retSelf.mobAttack = false

    

    -- getters and setters
    function clsTurtle.getX(self) return self.x end
    function clsTurtle.setX(self, newVal) self.x = newVal end
    function clsTurtle.getY(self) return self.y end
    function clsTurtle.setY(self, newVal) self.y = newVal end
    function clsTurtle.getZ(self) return self.z end
    function clsTurtle.setZ(self, newVal) self.z = newVal end
    function clsTurtle.getFacing(self) return self.facing end
    function clsTurtle.setFacing(self, newVal)
        local direction = {"south","west","north","east"}
        self.facing = newVal
        if self.facing < 0 then
            self.facing = 3
        elseif self.facing > 3 then
            self.facing = 0
        end
        self.compass = direction[self.facing + 1]
    end
    function clsTurtle.getCompass(self) return self.compass end
    function clsTurtle.getPlaceItem(self) return self.placeItem end
    function clsTurtle.setPlaceItem(self, item, useDamage)
        local success = false
        local slot = clsTurtle.getItemSlot(self, item, useDamage)
        if slot > 0 then
            self.placeItem = item
        end
    end
    function clsTurtle.getEquipped(self, side)
        local retValue = ""
        if side == "left" then
            retValue = self.equippedLeft
        else
            retValue = self.equippedRight
        end
        return retValue
    end
    function clsTurtle.setEquipped(self, side, value)
        if side == "left" then
            self.equippedLeft = value
        elseif side == "right" then
            self.equippedRight = value
        end
    end


    function clsTurtle.changeCoords(self, direction)
        --  0 = go south (z increases)
        --  1 = go west  (x decreases)
        --  2 = go north (z decreases
        --  3 = go east  (x increases)
        if direction == "forward" then
            if self.facing == 0 then
                self.z = self.z + 1 
            elseif self.facing == 1 then
                self.x = self.x - 1
            elseif self.facing == 2 then
                self.z = self.z - 1
            else
                self.x = self.x + 1
            end
        elseif direction == "back" then
            if self.facing == 0 then
                self.z = self.z - 1
            elseif self.facing == 1 then
                self.x = self.x + 1
            elseif self.facing == 2 then
                self.z = self.z + 1
            else
                self.x = self.x - 1
            end
        end
    end

    function clsTurtle.forward(self, steps)   
        steps = steps or 1
        local result, data
        local success = true
        local retryMove = 10
        
        clsTurtle.refuel(self, steps)
        turtle.select(1)
        for i = 1, steps do
            while turtle.detect() do -- allow for sand/gravel falling
                if not clsTurtle.dig(self, "forward") then-- cannot dig. either bedrock or in server protected area
                    success = false
                    if clsTurtle.getBlockType(self, "forward") == "minecraft:bedrock" then
                        print("Bedrock in front:function exit")
                    end
                    break
                end
            end
            success = false
            if turtle.forward() then
                success = true
            else
                if self.mobAttack then
                    if clsTurtle.attack(self, "forward") then
                        if turtle.forward() then
                            success = true
                        end
                    else                
                        result, data = turtle.forward()
                        print(data..":function exit")
                        break
                    end
                else
                    while not turtle.forward() do
                        clsTurtle.saveToLog(self, "Waiting for mob to leave...", true)
                        sleep(5)
                        retryMove = retryMove - 1
                        if retryMove <= 0 then
                            break
                        end
                    end
                    if retryMove  <= 0 then 
                        if clsTurtle.attack(self, "forward") then
                            if turtle.forward() then
                                success = true
                            end
                        else                
                            result, data = turtle.forward()
                            print(data..":function exit")
                            break
                        end
                    end
                end
            end
            if success then
                clsTurtle.changeCoords(self, "forward")
            end
        end
        return success
    end

    function clsTurtle.back(self, steps)
        steps = steps or 1
        local success = false
        
        clsTurtle.refuel(self, steps)
        turtle.select(1)
        for i = 1, steps do
            if not turtle.back() then --cant move back
                clsTurtle.turnRight(self, 2) --face backward direction
                if clsTurtle.forward(self, 1) then-- will also attack mobs if in the way
                    success = true
                    clsTurtle.changeCoords(self, "back")
                end
                clsTurtle.turnRight(self, 2)
            end
        end
        
        return success
    end

    function clsTurtle.up(self, steps)
        steps = steps or 1
        local success = false
        clsTurtle.refuel(self, steps)
        turtle.select(1)
 
        for i = 1, steps do
            if turtle.detectUp() then -- block above
                if clsTurtle.getBlockType(self, "up") == "minecraft:bedrock" then
                    print("Bedrock above:function exit")
                    break
                else
                    clsTurtle.dig(self, "up")
                end
            end
            if turtle.up() then  --move up unless mob in the way
                success = true
            else
                if clsTurtle.attack(self, "up") then -- attack succeeded
                    if turtle.up() then
                        success = true
                    end
                end
            end
            if success then
                self.y = self.y + 1
            end
        end
        return success
    end

    function clsTurtle.down(self, steps)
        steps = steps or 1
        local success = false
        
        clsTurtle.refuel(self, steps)
        turtle.select(1)
        for i = 1, steps do
            if turtle.detectDown() then -- block below
                if clsTurtle.getBlockType(self, "down") == "minecraft:bedrock" then
                    break
                else
                    turtle.digDown()
                end 
            end
            if turtle.down() then --move down unless mob in the way
                success = true
            else -- not bedrock, could be mob or minecart
                if clsTurtle.attack(self, "down") then -- attack succeeded
                    if turtle.down() then
                        success = true
                    end
                end
            end
            if success then
                self.y = self.y - 1
            end
        end
        
        return success
    end

    function clsTurtle.turnLeft(self, steps)
        steps = steps or 1
        for i = 1, steps do
            turtle.turnLeft()
            self.facing = self.facing - 1
            if self.facing < 0 then
                self.facing = 3
            end
        end
    end
 
    function clsTurtle.turnRight(self, steps)
        steps = steps or 1
        for i = 1, steps do
            turtle.turnRight()
            self.facing = self.facing + 1
            if self.facing > 3 then
                self.facing = 0
            end
        end
    end

    function clsTurtle.checkInventoryForItem(self, item, minQuantity, altItem, altMinQuantity)  
        -- request player to add items to turtle inventory
        clsTurtle.clear(self)
        minQuantity = minQuantity or 1
        altItem = altItem or ""
        altMinQuantity = altMinQuantity or 0
        local gotItemSlot = 0
        local gotAltItemSlot = 0
        local damage = 0
        local count = 0
        print("Add "..item.." to any single slot "..minQuantity.." needed")
        if altItem ~= "" then
            print("Or add "..altItem.." to any slot "..altMinQuantity.." needed")
        end
        while (count < minQuantity + altMinQuantity) do
            gotItemSlot, damage, count = clsTurtle.getItemSlot(self, item, -1) -- 0 if not present. return slotData.leastSlot, slotData.leastSlotDamage, total, slotData -- first slot no, integer, integer, table
            if gotItemSlot > 0 and count >= minQuantity then
                break
            else
                sleep(0.5)
            end
            if altItem ~= "" then
                gotAltItemSlot, damage, count = clsTurtle.getItemSlot(self, altItem, -1)
                if gotAltItemSlot > 0 and count >= altMinQuantity then
                    break   
                else
                    sleep(0.5)
                end
            end
            coroutine.yield()
        end
    end

    function clsTurtle.dig(self, direction)
        direction = direction or "forward"
        local success = false
        turtle.select(1)
        if direction == "up" then
            while turtle.digUp() do
                sleep(0.7)
                success = true
            end
        elseif direction == "down" then
            if turtle.digDown() then
                success = true
            end
        else -- forward by default
            while turtle.dig() do
                sleep(0.7)
                success = true
            end
        end
        return success
    end

    function clsTurtle.drop(self, slot, direction, amount)
        direction = direction or "forward"
        turtle.select(slot)
        local success = false
        if direction == "up" then
            if amount == nil then
                if turtle.dropUp() then
                    success = true
                end
            else
                if turtle.dropUp(amount) then
                    success = true
                end
            end
        elseif direction == "down" then
            if amount == nil then
                if turtle.dropDown() then
                    success = true
                end
            else
                if turtle.dropDown(amount) then
                    success = true
                end
            end
        else
            if amount == nil then
                if turtle.drop() then
                    success = true
                end
            else
                if turtle.drop(amount) then
                    success = true
                end
            end
        end
        return success
    end

    function clsTurtle.dropItem(self, item, keepAmount, direction)
        keepAmount = keepAmount or 0
        direction = direction or "down"
        local itemSlot = 0
        local stockData = {}
        
        if keepAmount <= 0 then -- drop everything
            itemSlot = clsTurtle.getItemSlot(self, item)
            while itemSlot > 0 do
                clsTurtle.drop(self, itemSlot, direction)
                itemSlot = clsTurtle.getItemSlot(self, item)
            end
        elseif keepAmount >= 64 then -- drop everything else
            stockData = clsTurtle.getStock(self, item)
            if item == "minecraft:log" then
                if stockData.mostSlot ~= stockData.leastSlot then
                    clsTurtle.drop(self, stockData.leastSlot, direction)
                end
            else
                while stockData.total > keepAmount do
                    if stockData.mostSlot ~= stockData.leastSlot then
                        clsTurtle.drop(self, stockData.leastSlot, direction)
                    else --only one slot but more than required in it
                        clsTurtle.drop(self, stockData.mostSlot, direction)
                    end
                    stockData = clsTurtle.getStock(self, item)
                end
            end
        else --store specific amount
            itemSlot = clsTurtle.getItemSlot(self, item)
            local dropCount = turtle.getItemCount(itemSlot) - keepAmount
            if itemSlot > 0 then
                clsTurtle.drop(self, itemSlot, direction, dropCount)
            end
        end
    end


    function clsTurtle.dumpRefuse(self)
        --dump dirt, cobble, sand, gravel
        local itemlist = {}
        local blockType = ""
        local blockModifier
        local slotCount
        local cobbleCount = 0
        local dirtCount = 0
 
        itemlist[1] = "minecraft:gravel"
        itemlist[2] = "minecraft:stone" --includes andesite, diorite etc
        itemlist[3] = "minecraft:dirt"
        itemlist[4] = "minecraft:flint"
        for x = 1, 15 do
            for i = x + 1 , 16 do
                if turtle.getItemCount(i) > 0 then
                    turtle.select(i)
                    if turtle.compareTo(x) then
                        turtle.transferTo(x)
                    end
                end
            end
        end
        for i = 1, 16 do
            slotCount, blockType, blockModifier = clsTurtle.getSlotContains(self, i)
            if blockType == "minecraft:cobblestone" then
                if cobbleCount > 0 then
                    turtle.select(i)
                    turtle.drop()
                else
                    cobbleCount = cobbleCount + 1
                end
            end
            for j = 1, 4 do
                if blockType == itemlist[j] then
                    turtle.select(i)
                    turtle.drop()
                    break
                end
            end
        end
        turtle.select(1)
    end

    return retSelf
end