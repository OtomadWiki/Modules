local switch = {}

function switch.switch(...)
				local s = {}
				local args = table.pack(...)
				for k,v in pairs(args) do
								s[k] = (k and {nil} or {v})[1]
    			end
				return s
end

return switch