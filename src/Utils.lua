local U = {}

-- foldr(function, default_value, table)
-- e.g: foldr(operator.mul, 1, {1,2,3,4,5}) -> 120
function U.foldr(f, val, tbl)
	for i,v in pairs(tbl) do
		val = func(val, v)
	end
	return val
end

-- reduce(function, table)
-- e.g: reduce(operator.add, {1,2,3,4}) -> 10
function reduce(f, tbl)
	return foldr(f, head(tbl), tail(tbl))
end

-- filter(function, table)
-- e.g: filter(is_even, {1,2,3,4}) -> {2,4}
function U.filter(f, tbl)
	local newtbl= {}
	for i,v in pairs(tbl) do
		if func(v) then
		newtbl[i]=v
		end
	end
	return newtbl
end

-- map(function, table)
-- e.g: map(double, {1,2,3})    -> {2,4,6}
function U.map(f, tbl)
	local newtbl = {}
	for i,v in pairs(tbl) do
		newtbl[i] = func(v)
	end
	return newtbl
end

function U.isInArray(val, t)
	for _, v in ipairs(t) do
		if v == val then
			return true
		end
	end
	return false
end

function U.isInDict(val, t)
	for k, v in pairs(t) do
		if v == val or k == val then
			return true
		end
	end
	return false
end

function U.switch(self, args)
	local input = self or true
	for k, v in pairs(args) do
		if k == input then
			if k then
				return v
			end
		end
	end
end

return U
