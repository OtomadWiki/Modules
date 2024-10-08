local C = {}
C.classMeta = {
	__call = function(cls, ...)
		local instance = {}
		setmetatable(instance, cls)
		instance:_init(...)
		return instance
	end,
}
C.new = C.classMeta.__call

function C.createClass(metatable)
	return function(definition)
		definition.__index = definition
		setmetatable(definition, metatable)
		return definition
	end
end
function C.derive(...)
	-- "cls" is the new class
	local cls, bases = {}, { ... }
	-- copy base class contents into the new class
	for i, base in ipairs(bases) do
		for k, v in pairs(base) do
			cls[k] = v
		end
	end
	-- set the class's __index, and start filling an "instanceOf" table that contains this class and all of its bases
	-- so you can do an "instance of" check using my_instance.instanceOf[MyClass]
	cls.__index, cls.instanceOf = cls, { [cls] = true }
	for i, base in ipairs(bases) do
		for c in pairs(base.instanceOf) do
			cls.instanceOf[c] = true
		end
		cls.instanceOf[base] = true
	end
	-- the class's __call metamethod
	setmetatable(cls, C.classMeta)
	-- return the new class table, that's ready to fill with methods
	return cls
end
C.class = C.createClass(C.classMeta)

local class, derive = C.class, C.derive
C.Nothing = {
	value = nil,
}
C.Just = class({
	_init = function(self, x)
		self.value = x
	end,
	fmap = function(self, f)
		self.value = f(self.value)
		return self
	end,
})

return C
