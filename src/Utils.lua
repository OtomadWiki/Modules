local u = {}

function u.isInArray(val, t)
  for _, v in ipairs(t) do
    if v == val then
      return true
    end
  end
  return false
end

function u.isInDict(val, t)
  for k, v in pairs(t) do
    if v == val or k == val then
      return true
    end
  end
  return false
end

function u.switch(self, args)
  local input = self or true
  for k,v in pairs(args) do
    if k==input then
      if k then return v end
    end
  end
end

return u
