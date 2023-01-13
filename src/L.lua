local L={}

local getArgs = require('Module:Arguments').getArgs
local isInArray = require('Module:Utils').isInArray
local isInDict = require('Module:Utils').isInDict
local yesno = require('Module:Yesno')
--local html = mw.html.create()

local linksTable = {
  ['bv'] = 'https://www.bilibili.com/video/BV',
  ['av'] = 'https://www.bilibili.com/video/av',
  ['sm'] = 'https://nicovideo.jp/watch/sm',
  ['nm'] = 'https://nicovideo.jp/watch/nm',
  ['ac'] = 'https:///www.acfun.cn/v/ac',
  ['au'] = 'https://www.bilibili.com/audio/au',
  ['cv'] = 'https://www.bilibili.com/read/cv',
  ['rl'] = 'https://www.bilibili.com/read/readlist/rl',
  ['ml'] = 'https://www.bilibili.com/medialist/play/ml',
  ['ep'] = 'https://www.bilibili.com/bangumi/play/ep',
  ['ss'] = 'https://www.bilibili.com/bangumi/play/ss',
  ['im'] = 'https://seiga.nicovideo.jp/seiga/im',
  ['pid'] = 'https://www.pixiv.net/artworks/',
  ['uid'] = 'https://space.bilibili.com/',
}

function L.isValidNum(frame)
	local frame = frame or {}
	local args = getArgs(frame)
	local num = linksTable[args[1]:sub(1, 2):lower()] and args[1]:sub(1, 2):lower() or args[1]:sub(1, 3):lower()
	return (isInDict(num, linksTable) and "yes" or "no")
end

function L.generate(frame)
	local frame = frame or {}
	local args = getArgs(frame)

	local num = args['archive'] or args[1]
	local prefix = linksTable[num:sub(1, 3):lower()] and num:sub(1, 3):lower() or num:sub(1, 2):lower()
	local digit = num:sub(#prefix + 1)
	local part = args["p"]~='1' and args["p"]
	local status = args["status"]
	local option = args["option"]

    if not linksTable[prefix] then error("请指定正确的作品号及其前缀！") end
	local link = linksTable[prefix] .. 
		digit .. ( part and "?p=".. part or '' )
	local text = args[2] or num
	local category = option ~= "nocategory" and "[[分类:有失效链接的页面]]" or ""
	local partText = part and "<sup>第"..part.."P</sup>" or ''
	local titleText
	if args['archive'] then
		titleText = "原视频号为 " .. args[1]
	elseif args['origin'] then
		titleText = "此视频搬运自 " .. args['origin']
	else
		titleText = status and "此作品目前处于" .. status .. "状态。" or num
	end

	local res
	local output = ( yesno(args['pl']) and '' or '%s[' ) ..
			link ..
			( yesno(args['pl']) and '' or ' %s]%s' )
	local statusTable = {normal = output:format('', "<span title='"..
		titleText..
		"'>"..text..partText.."</span>", ''),}
	if status and args['archive']==nil then
		statusTable = {
			normal = statusTable.normal,
			invalidLink = output:format(category ..
				"<span class='plainlinks'>", "<span title='"..titleText.."' style='color:grey'><s>"..text..partText.."</s></span>", "</span>"),
			invalidPart = output:format(category, "<span title='"..titleText.."'>" .. text .. "<span style='color:grey'>"..partText.."</span>", ''),
			reproduceProhibited = statusTable.normal .. "<span style='color:red'><small>（禁止转载）</small></span>",
		}
		if isInArray(status, {"失效", "删除", "削除", "非公开"}) then
			res = statusTable.invalidLink
		elseif part and isInArray(status, {"分p失效", "分p删除", "分p削除"}) then
			res = statusTable.invalidPart
		elseif status == "禁止转载" then
			res = statusTable.reproduceProhibited
		else
			res = statusTable.normal
		end
	else
		res = statusTable.normal
	end
	return res
end

return L
