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

function u.nowiki(frame)
  local getArgs = require('Module:Arguments').getArgs
	local frame = frame or {}
  local args = getArgs(frame)
  return "<nowiki>"..args[1].."</nowiki>"
end

--[=[
function html:addTag(...)
	local args, tagName, wikitext, className,attr, style, parent
	if #{...} == 1 then
        args = ...
		tagName = args.tagName
		wikitext = args.wikitext
		className = args.className
		attr = args.attr
		style = args.style
	else
		tagName, wikitext, className, attr, style, parent = ...
	end
	local output = self:tag(tagName):wikitext(wikitext)
	if attr then output = output:attr(attr) end
	if className then output = output:addClass(className) end
	if style then output = output:cssText(style) end
	parent = output
	output.addTag = function() return html:addTag(tagName, wikitext, className, attr, style, parent) end
	output.done = function() return parent or self end
	return output--:done
end
--]=]
return u
