local u = {}

function u.isInArray(val, t)
	for _, v in ipairs(t) do
		if v == val then
			return true
		end
	end
	return false
end

function u.switch(self, args)
	local input = self or true
	for k,v in ipairs(args) do
		if k==input then
			if k then return v end
		end
	end
end

local function isInDict(kv, t)
	local key = kv.key
	local value = kv.value
	for k, v in ipairs(t) do
		if k == key or v == val then
			return true
		end
	end
	return false
end

return u
