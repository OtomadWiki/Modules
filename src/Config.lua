local Config = {}

function Config.set(...)
    local args = table.pack(...)
    local module = args[1]
    local func = args[2]
    for k,v in args do
        _G.k = v;
    end
end

return Config