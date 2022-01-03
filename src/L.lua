local L={}

package.path = 'lua_modules/?/?.lua'
local mw = require("mw")
local getArgs = require('Arguments').getArgs
local yesno = require('Yesno')
--local libraryUtil = require('libraryUtil')
--local checkType = libraryUtil.checkType
local html = mw.html.create()

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

local function isInArray(val, t)
	for _, v in ipairs(t) do
		if v == val then
			return true
		end
	end
	return false
end

function html:addTag(...)
	local self = self or html
	local args, tagName, wikitext, className,attr, style
	if #{...} == 1 then
        args = ...
		tagName = args.tagName
		wikitext = args.wikitext
		className = args.className
		attr = args.attr
		style = args.style
	else
		tagName, wikitext, className, attr, style = ...
	end
	local output = self:tag(tagName):wikitext(wikitext)
	if attr then output = output:attr(attr) end
	if className then output = output:addClass(className) end
	if style then output = output:cssText(style) end
	return output--:done()
end

function L.generate(frame, options)
	frame = frame or {}
	options = options or {}
	local args = getArgs(frame)

	local num = args['archive'] or args[1]
	local prefix = ( linksTable[num:sub(1, 3)] and string.lower(num:sub(1, 3)) ) or string.lower(num:sub(1, 2))
	local digit = num:sub(3)
	local part = args["p"] == 1 and args["p"]
	local status = args["状态"]

	local link = linksTable[prefix] .. digit .. (( part ~= '1' and part ) and "?p=".. part or '' )
	local text = args[2] or args[1]
	local partText = ( part and "<sup>第"..part.."P</sup>" ) or ''
	local errorMessage = html:addTag("strong", "请指定正确的作品号及其前缀！", "error"):done()
		:addTag("span", "可用的作品号前缀参见 [[Template:L]]。")

	local res
	local function output(statText)
		return ( yesno(args['pl']) and '' or '[' ) ..
			link ..
			( yesno(args['pl']) and '' or ' ' .. tostring(statText) .. ']' )
	end
	if status then
		local statusTable = {
			normal = html:addTag("span", text .. partText),
			invalidLink = html:addTag("span", "[[分类:有失效作品链接的页面]]<span style='color:grey'><s>" ..
				text .. partText ..
				"</s></span>", "plainlinks"),
			invalidPart = html:addTag("span", "[[分类:有失效作品链接的页面]]<span style='color:grey'><s>" ..
				text ..
				
				"{{color|grey|<s>" ..
				partText ..
				"</s></span>", "plainlinks"),
			reproduceProhibited = html:addTag("span", text..partText):done()
			:addTag({tagName="span", wikitext="<small>（禁止转载）</small>", style="color:red"}),
		}
		if isInArray(status, {"失效", "删除", "削除"}) then
			res = output(statusTable.invalidLink)
		elseif isInArray(status, {"分p失效", "分p删除", "分p削除"}) then
			res = output(statusTable.invalidPart)
		elseif status == "禁止转载" then
			res = output(statusTable.reproduceProhibited)
		else
			res = output(statusTable.normal)
		end
	else
		res = output(html:addTag("span", text .. partText))
	end
	return res
end

return L