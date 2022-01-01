local L={}
local getArgs = require('Module:Arguments').getArgs
local yesno = require('Module:Yesno')

local linksTable = {
  ['bv'] = 'https://www.bilibili.com/video/BV',
  ['av'] = 'https://www.bilibili.com/video/av',
  ['sm'] = 'https://nicovideo.jp/watch/sm',
  ['nm'] = 'https://nicovideo.jp/watch/nm',
  ['ac'] = 'https:///acfun.cn/v/ac',
  ['au'] = 'https://www.bilibili.com/audio/au',
  ['cv'] = 'https://www.bilibili.com/read/cv',
  ['rl'] = 'https://www.bilibili.com/read/readlist/rl',
  ['ml'] = 'https://www.bilibili.com/medialist/play/ml',
  ['ep'] = 'https://www.bilibili.com/bangumi/play/ep',
  ['ss'] = 'https://www.bilibili.com/bangumi/play/ss',
  ['im'] = 'https://seiga.nicovideo.jp/seiga/im',
  ['pid'] = 'https://www.pixiv.net/artworks/',
  ['uid'] = 'https://space.bilibili.com/uid',
}
local statusTable = {
  ['删除'] = '<s>%s</s>',
}

function L.generate(frame)
	local args = getArgs(frame)

	local num = ( args['archive']~=nil and {args['archive']} or {args[1]})[1]
	local prefix = linksTable[num:sub(1, 3)] and string.lower(num:sub(1, 3)) or string.lower(num:sub(1, 2))
	local digit = num:sub(3)
	local link = linksTable[prefix] .. digit

	local text = args[2] or args[1]
	local part = args["p"]
	local status = args["状态"]

	local html = mw.html.create()
	local errorMessage = html
		:tag("strong"):addClass("error"):wikitext("请指定正确的作品号及其前缀！"):done()
		:tag():wikitext("可用的作品号前缀参见 [[Template:L]]。"):done()
	local partText = part and tostring(html
		:tag("sup"):wikitext("第"..part.."P")) or ''

	local plainLinks = html
	:tag("span"):addClass("plainlinks"):wikitext("[[分类:有失效作品链接的页面]]{{color|grey|<s>" ..
		text ..
		partText ..
		"</s>}}"):done()

	local res = ( yesno(args['pl']) == 'y' ) and '' or '[' ..
        link ..  ( part and "?p="..part or '' ) ..
        ( yesno(args['pl']) == 'y' and '' or ' '..text..']' )
	return res
end

return L