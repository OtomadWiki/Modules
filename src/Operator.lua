return {
	----------------------------------------------------------------------------
	-- Comparison operators
	----------------------------------------------------------------------------
	lt = function(a, b)
		return a < b
	end,
	le = function(a, b)
		return a <= b
	end,
	eq = function(a, b)
		return a == b
	end,
	ne = function(a, b)
		return a ~= b
	end,
	ge = function(a, b)
		return a >= b
	end,
	gt = function(a, b)
		return a > b
	end,

	----------------------------------------------------------------------------
	-- Arithmetic operators
	----------------------------------------------------------------------------
	add = function(a, b)
		return a + b
	end,
	div = function(a, b)
		return a / b
	end,
	floordiv = function(a, b)
		return math.floor(a / b)
	end,
	intdiv = function(a, b)
		local q = a / b
		if a >= 0 then
			return math.floor(q)
		else
			return math.ceil(q)
		end
	end,
	mod = function(a, b)
		return a % b
	end,
	mul = function(a, b)
		return a * b
	end,
	neq = function(a)
		return -a
	end,
	unm = function(a)
		return -a
	end, -- an alias
	pow = function(a, b)
		return a ^ b
	end,
	sub = function(a, b)
		return a - b
	end,
	truediv = function(a, b)
		return a / b
	end,

	----------------------------------------------------------------------------
	-- String operators
	----------------------------------------------------------------------------
	concat = function(a, b)
		return a .. b
	end,
	len = function(a)
		return #a
	end,

	----------------------------------------------------------------------------
	-- Logical operators
	----------------------------------------------------------------------------
	and_ = function(a, b)
		return a and b
	end,
	or_ = function(a, b)
		return a or b
	end,
	not_ = function(a)
		return not a
	end,
	truth = function(a)
		return not not a
	end,
}