local Config = {}

function Config.set(...)
    local args = table.pack(...)
    local module = args[1]
    local func = args[2]
    local req = require(module)
end

return Config