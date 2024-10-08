local L = {}

local getArgs = require("Module:Arguments").getArgs
local isInArray = require("Module:Utils").isInArray
local yesno = require("Module:Yesno")
local linksTable = require("Module:L/Data")
local mw = mw or {}

function L.paramTable(part, time)
	return { ["p"] = part, ["t"] = time }
end

function L.parseParam(paramTable)
	local formatedText = {}
	local spliter = "?"
	for k, v in pairs(paramTable) do
		spliter = #formatedText == 0 and "?" or "&"
		-- mw.log(k, v)
		if #v > 0 then
			table.insert(formatedText, spliter .. mw.text.nowiki(k .. "=" .. v))
		end
	end
	return table.concat(formatedText, "")
end

function L.statusTable(titleText, text, partText, category)
	-- TODO 使用mediawiki自带模块处理html
	return {
		normal = { "", "<span title='" .. titleText .. "'>" .. text .. partText .. "</span>", "" },
		invalidLink = {
			category .. "<span class='plainlinks'>",
			"<span title='" .. titleText .. "' style='color:grey'><s>" .. text .. partText .. "</s></span>",
			"</span>",
		},
		invalidPart = {
			category,
			"<span title='" .. titleText .. "'>" .. text .. "<span style='color:grey'><s>" .. partText .. "</s></span>",
			"",
		},
		reproduceProhibited = {
			"",
			"<span title='" .. titleText .. "'>" .. text .. partText .. "</span>",
			"<span style='color:red'><small>（禁止转载）</small></span>",
		},
	}
end

function L.parseStatus(statusTable, status)
	local formatedText
	if isInArray(status, { "失效", "删除", "削除", "非公开" }) then
		formatedText = statusTable.invalidLink
	elseif isInArray(status, { "分p失效", "分p删除", "分p削除" }) then
		formatedText = statusTable.invalidPart
	elseif status == "禁止转载" then
		formatedText = statusTable.reproduceProhibited
	else
		formatedText = statusTable.normal
	end
	return formatedText
end

function L.titleText(archive, id, status)
	if archive then
		return "原视频号为 " .. id
	end
	return status and "此作品目前处于" .. status .. "状态。" or id
end

function L.genLink(prefixToLink, params, id)
	local prefix = prefixToLink[id:sub(1, 3):lower()] and id:sub(1, 3):lower() or id:sub(1, 2):lower()

	local digit = id:sub(#prefix + 1)
	if not prefixToLink[prefix] then
		return id
	end
	local link = linksTable[prefix] .. digit .. params
	return link
end

function L.output(pl, link, formatter, fstring)
	if pl then
		return link
	end
	return fstring:format(unpack(formatter))
end

function L.generate(frame)
	--[=[
      生成特定号码对应链接的模块
      @param 第一个参数，默认的视频号，会被archive参数覆盖
      @param 第二个参数，默认的显示文本，为空时被第一个参数或archive参数覆盖
      @param status 状态
      @param p 分p号
      @param t 时间号
      @param archive 搬运地址或者视频号
      @param origin 原地址或者视频号，没什么用，准备deprecate
      @param option 样式的设置
      @return html
    --]=]
	local args = getArgs(frame)

	local id = args[1]
	local text = args[2] or id
	local archive = args["archive"] or args["转载"] or args["补档"]
	local status = args["status"] or args["状态"]
	local option = args["option"]
	local pl = yesno(args["pl"])

	local timeStr = args["t"] or "" -- TODO 播放时间点解析器
	local partNum = args["p"] and tonumber(args["p"]) or 1
	local partStr = partNum > 1 and args["p"] or ""
	local params = L.parseParam(L.paramTable(partStr, timeStr))
	local link = L.genLink(linksTable, params, id)

	local category = option ~= "nocategory" and "[[分类:有失效链接的页面]]" or "" -- TODO 选项解析器
	local partText = (partNum > 1 and "<sup>第" .. partStr .. "P</sup>") or ""
	local titleText = L.titleText(archive, id, status)

	local formatter = L.parseStatus(L.statusTable(titleText, text, partText, category), status)
	local output = L.output(pl, link, formatter, "%s[" .. link .. "%s]%s")

	if archive then
		output = output .. '<span class="repost-circle">[' .. L.genLink(linksTable, "", archive) .. " 转]</span>"
	end

	return output
end

return L
