local position = require ".libs.lua.turtle.position"

print("WHERE DAFUQ I AM BICH")
print("GIVE THe X: ")

local x = read()

print("GIVE THE Y: ")
local y = read()

print("NOW THE Z: ")
sleep(0.5)
print("WHY U SO SLOW FFS")
local z = read()

print("THANK YOU")

sleep(0.3)
write(". ")
sleep(0.3)
write(". ")
sleep(0.3)
print(".")

print("Where am i lookin?")
print("Is this NORPH????")


local insults = {
    "Jesus! you are dumb",
    "Can you read??",
    "Try again bozo",
    "wow",
    "Mate pls",
    "How can somebody fail this bad? Its incredible",
    "FFS... You should be a case study.. \n\"Finding humanity's lowest IQ score\"",
    "Just CTRL+T ... make it STOP... PLEEEEaAASSSSEEE"
}

local is_first = true
local dir = read()
local i = 1
local insult
while dir ~= "N" and dir ~= "S" and dir ~= "E" and dir ~= "W" do
    if is_first then
        print("Possible choices are [ N | S | E | W ]")
        sleep(0.15)
        print("dumbass..")
        is_first = false

    else
        insult = insults[i]
        if insult then
            print(insult)
        else
            print("kill mee")
        end
        print("Possible choices are [ N | S | E | W ]")
        i = i + 1
    end
end

print("That wasn't so hard was it :D")
print("Bye o/ and .l. you")

local maps = {
    N = position.NORTH,
    S = position.SOUTH,
    E = position.EAST,
    W = position.WEST,
}


position.setPosition(x,y,z,maps[dir])
position.savePosition()

