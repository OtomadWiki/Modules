local p={}
local getArgs = require('Module:Arguments').getArgs
local yesno = require('Module:Yesno')

local linksTable = {
  ['BV'] = 'https://bilibili.com/video/BV',
  ['av'] = 'https://bilibili.com/video/av',
  ['sm'] = 'https://nicovideo.jp/watch/sm',
}
local statusTable = {
  ['删除'] = '<s>%s</s>',
}

function p.generate(frame)
	local args = getArgs(frame)

	local num = (args['archive']~=nil and {args['archive']} or {args[1]})[1]
	local prefix = string.lower(num:sub(1, 2))
	local digit = num:sub(3)
	local link = linksTable[prefix] .. digit

	local text = args[2]
	local part = args["p"]
	local status = args["状态"]

  local res = yesno(args['pl']) == 'y' and '' or '[' ..
				link .. (part and part or '') ..
				yesno(args['pl']) == 'y' and '' or ('' ..
				  ' ' ..
				  text ..
				  ']')
  return res
end

return p
