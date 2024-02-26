local file = {}


-- Creates a file if it doesn't exist
function file.createIfNotExists(path)
    local clean_path = shell.resolve(path)
    fs.open(clean_path, "a").close()
end


return file