local switch = {}

function switch.switch(...)
	local s = {}
	local args = table.pack(...)
	local keys, values = {},{}
	for k,v in pairs(args) do
		if v == nil then
			keys = table.insert(k)
			values = table.insert(v)
			s[keys] = values
		else
			s[k] = (k and {nil} or {v})[1]
			values = v
			keys = k
		end
	end
	return s
end

return switch