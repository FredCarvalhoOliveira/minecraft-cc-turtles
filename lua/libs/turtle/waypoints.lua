local wp = {}

local function readFile(path)
    local f = fs.open(path, "r")
    if f == nil then
        return nil
    end
    local raw = f.readAll()
    f.close()
    return raw
end

local function writeFile(path, content)
    local f = fs.open(path, "w")
    f.write(content)
    f.close()
end

local raw = readFile("/.state/waypoints")
local saved_state
if raw == nil then
    saved_state = {}
else
    saved_state = textutils.unserialise(raw)
end

local function save()
    local content = textutils.serialise(saved_state)
    writeFile(content)
end

function wp.set(label, x, y, z)
    saved_state[label] = { x, y, z }
    save()
end

function wp.get(label)
    return saved_state[label]
end

function wp.remove(label)
    saved_state[label] = nil
    save()
end

function wp.getAll()
    return saved_state
end

return wp