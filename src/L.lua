local L = {}

local getArgs = require('Module:Arguments').getArgs
local isInArray = require('Module:Utils').isInArray
local isInDict = require('Module:Utils').isInDict
local yesno = require('Module:Yesno')
-- local html = mw.html.create()

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
    ['uid'] = 'https://space.bilibili.com/'
}
local function parseParam(paramTable)
    local res = {}
	local spliter = #res == 0 and '?' or '&'
    for k, v in pairs(paramTable) do
    	-- mw.log(k, v)
        if #v > 0 then
            table.insert(res, spliter .. mw.text.nowiki(k .. '=' .. v))
        end
    end
    return table.concat(res, '')
end

function L.isValidNum(frame)
    local frame = frame or {}
    local args = getArgs(frame)
    local num = linksTable[args[1]:sub(1, 2):lower()] and
                    args[1]:sub(1, 2):lower() or args[1]:sub(1, 3):lower() -- 针对三字母前缀等情况
    return (isInDict(num, linksTable) and "yes" or "no")
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
    local frame = frame or {}
    local args = getArgs(frame)

    local num = args['archive'] or args[1]
    local text = args[2] or num
    local status = args["status"] or ""
    local option = args["option"]
    local prefix =
        linksTable[num:sub(1, 3):lower()] and num:sub(1, 3):lower() or
            num:sub(1, 2):lower()
    local digit = num:sub(#prefix + 1)
    local part = args["p"] and tostring(args["p"]) ~= '1' and tostring(args["p"]) or "" -- 为 1 的时候忽略该值
    local _time = args["t"] and tostring(args["t"]) or ""
    local paramTable = {["p"] = part, ["t"] = _time}

    -- TODO 拆分错误处理函数或者模块
    if not linksTable[prefix] then
        error("请指定正确的作品号及其前缀！")
    end

    -- TODO 使用特定模块或者方法处理分类或者链接参数
    local link = linksTable[prefix] .. digit .. parseParam(paramTable)
    local category = option ~= "nocategory" and
                         "[[分类:有失效链接的页面]]" or ""
    local partText = (#part > 0 and "<sup>第" .. part .. "P</sup>") or ''
    local titleText

    if args['archive'] then
        titleText = "原视频号为 " .. args[1]
    elseif args['origin'] then
        titleText = "此视频搬运自 " .. args['origin']
    else
        titleText = #status > 0 and "此作品目前处于" .. status ..
                        "状态。" or num
    end

    -- TODO 使用mediawiki自带模块处理html
    local res
    local output = (yesno(args['pl']) and '' or '%s[') .. link ..
                       (yesno(args['pl']) and '' or ' %s]%s')
    local statusTable = {
        normal = output:format('',
                               "<span title='" .. titleText .. "'>" .. text ..
                                   partText .. "</span>", '')
    }
    if #status > 0 and #args['archive'] > 0 then
        statusTable = {
            normal = statusTable.normal,
            invalidLink = output:format(category .. "<span class='plainlinks'>",
                                        "<span title='" .. titleText ..
                                            "' style='color:grey'><s>" .. text ..
                                            partText .. "</s></span>", "</span>"),
            invalidPart = output:format(category,
                                        "<span title='" .. titleText .. "'>" ..
                                            text .. "<span style='color:grey'>" ..
                                            partText .. "</span>", ''),
            reproduceProhibited = statusTable.normal ..
                "<span style='color:red'><small>（禁止转载）</small></span>"
        }
        if status:isInArray({"失效", "删除", "削除", "非公开"}) then
            res = statusTable.invalidLink
        elseif #part > 0 and
            status:isInArray({"分p失效", "分p删除", "分p削除"}) then
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
