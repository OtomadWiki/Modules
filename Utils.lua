local u = {}

function u.isInArray(val, t)
	for _, v in ipairs(t) do
		if v == val then
			return true
		end
	end
	return false
end

function u.switch(args)
	for k,v in pairs(args) do
		if k==true then
			return v
		end
	end
end

return u