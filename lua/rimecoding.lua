local M = {}

-- =========================================================
-- rimecoding.lua
-- 功能：
-- 1. 加载多个外部词库：dict_common / dict_core / dict_ue / dict_project
-- 2. 合并词库，优先级：project > ue > core > common
-- 3. 长词优先替换
-- 4. 记录翻译后仍残留的未知中文
-- 5. Tab 提交翻译后的 CamelCase 英文
-- =========================================================

-- =========================
-- 路径与日志工具
-- =========================

local path_sep = package.config:sub(1, 1)

local function get_current_script_dir()
    local source = debug.getinfo(1, "S").source

    if type(source) == "string" and source:sub(1, 1) == "@" then
        local full_path = source:sub(2)
        local dir = full_path:match("^(.*[\\/])")
        if dir then
            return dir
        end
    end

    return "." .. path_sep
end

local script_dir = get_current_script_dir()

local load_debug_path = script_dir .. "rimecoding_load_debug.txt"
local unknown_words_path = script_dir .. "rimecoding_unknown_words.tsv"

local DEBUG = false

local function append_debug(text)
    if not DEBUG then
        return
    end

    local file = io.open(load_debug_path, "a")
    if file then
        file:write(os.date("%Y-%m-%d %H:%M:%S"), "\t", tostring(text), "\n")
        file:close()
    end
end
local function count_table(t)
    local count = 0

    if type(t) ~= "table" then
        return 0
    end

    for _, _ in pairs(t) do
        count = count + 1
    end

    return count
end

-- =========================
-- 安全加载词库
-- =========================

local function safe_load_dict(name)
    -- 重要：清掉 require 缓存，避免你改了 dict_ue.lua 但 Rime 还读旧版本
    package.loaded[name] = nil

    -- 方式一：require
    local ok_require, result_require = pcall(require, name)

    if ok_require and type(result_require) == "table" then
        append_debug("require success: " .. name .. " count=" .. count_table(result_require))
        return result_require
    end

    -- 方式二：从当前 rimecoding.lua 所在目录 dofile
    local file_path = script_dir .. name .. ".lua"
    local ok_dofile, result_dofile = pcall(dofile, file_path)

    if ok_dofile and type(result_dofile) == "table" then
        append_debug("dofile success: " .. file_path .. " count=" .. count_table(result_dofile))
        return result_dofile
    end

    append_debug(
        "load failed: "
        .. name
        .. " | require_ok="
        .. tostring(ok_require)
        .. " | require_result="
        .. tostring(result_require)
        .. " | dofile_path="
        .. tostring(file_path)
        .. " | dofile_ok="
        .. tostring(ok_dofile)
        .. " | dofile_result="
        .. tostring(result_dofile)
    )

    return {}
end

-- 词库加载
local dict_common = safe_load_dict("dict_common")
local dict_core = safe_load_dict("dict_core")
local dict_ue = safe_load_dict("dict_ue")
local dict_project = safe_load_dict("dict_project")

-- =========================
-- 合并词库
-- 优先级：project > ue > core > common
-- 后合并的覆盖先合并的
-- =========================

local dict = {}

local function merge_into(target, source)
    if type(source) ~= "table" then
        return
    end

    for k, v in pairs(source) do
        target[k] = v
    end
end

merge_into(dict, dict_common)
merge_into(dict, dict_core)
merge_into(dict, dict_ue)
merge_into(dict, dict_project)

append_debug("merged dict count=" .. count_table(dict))
append_debug("test 打开关卡=" .. tostring(dict["打开关卡"]))
append_debug("test 加载关卡=" .. tostring(dict["加载关卡"]))
append_debug("test 获取组件=" .. tostring(dict["获取组件"]))
append_debug("test 蓝莓=" .. tostring(dict["蓝莓"]))

-- =========================
-- 长词优先排序
-- =========================

local dict_keys = {}

for cn, _ in pairs(dict) do
    table.insert(dict_keys, cn)
end

table.sort(dict_keys, function(a, b)
    local len_a = utf8.len(a) or #a
    local len_b = utf8.len(b) or #b

    if len_a == len_b then
        return tostring(a) > tostring(b)
    end

    return len_a > len_b
end)

append_debug("dict_keys count=" .. tostring(#dict_keys))

-- =========================
-- Lua Pattern 安全处理
-- =========================

local function escape_pattern(s)
    return tostring(s):gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
end

local function escape_replacement(s)
    return tostring(s):gsub("%%", "%%%%")
end

-- =========================
-- 中文检测与未知词记录
-- =========================

local function is_chinese_code(code)
    return
        (code >= 0x4E00 and code <= 0x9FFF) or
        (code >= 0x3400 and code <= 0x4DBF)
end

local function collect_chinese_segments(text)
    local segments = {}
    local buffer = {}

    if type(text) ~= "string" then
        return segments
    end

    for _, code in utf8.codes(text) do
        local ch = utf8.char(code)

        if is_chinese_code(code) then
            table.insert(buffer, ch)
        else
            if #buffer > 0 then
                table.insert(segments, table.concat(buffer))
                buffer = {}
            end
        end
    end

    if #buffer > 0 then
        table.insert(segments, table.concat(buffer))
    end

    return segments
end

local unknown_words_cache = {}

local ENABLE_UNKNOWN_LOG = true

local function log_unknown_words(original_text, translated_text)
    if not ENABLE_UNKNOWN_LOG then
        return
    end

    local segments = collect_chinese_segments(translated_text)

    if #segments == 0 then
        return
    end

    local file = io.open(unknown_words_path, "a")
    if not file then
        append_debug("unknown log open failed: " .. tostring(unknown_words_path))
        return
    end

    for _, word in ipairs(segments) do
        if not unknown_words_cache[word] then
            unknown_words_cache[word] = true

            file:write(
                os.date("%Y-%m-%d %H:%M:%S"),
                "\t",
                word,
                "\t",
                tostring(original_text),
                "\t",
                tostring(translated_text),
                "\n"
            )
        end
    end

    file:close()
end
-- =========================
-- 翻译函数
-- =========================

-- 纯文本替换，不使用 Lua pattern
local function replace_plain(text, old, new)
    if old == "" then
        return text
    end

    local result = {}
    local start_pos = 1

    while true do
        local s, e = string.find(text, old, start_pos, true)

        if not s then
            table.insert(result, string.sub(text, start_pos))
            break
        end

        table.insert(result, string.sub(text, start_pos, s - 1))
        table.insert(result, new)

        start_pos = e + 1
    end

    return table.concat(result)
end

local function translate(text)
    if type(text) ~= "string" or text == "" then
        return text
    end

    -- 去掉首尾空白，避免候选词里带隐藏空格
    local result = text:gsub("^%s+", ""):gsub("%s+$", "")

    -- 先做完整命中
    -- 例如：打开关卡 -> OpenLevel
    if dict[result] ~= nil then
        return dict[result]
    end

    -- 再做组合替换
    -- 例如：获取蓝莓组件 -> GetBlueberryComponent
    for _, cn in ipairs(dict_keys) do
        local en = dict[cn]

        if en ~= nil then
            result = replace_plain(result, cn, en)
        end
    end

    return result
end
-- =========================
-- CamelCase 转换
-- =========================

local function toCamelCase(text)
    if type(text) ~= "string" then
        return ""
    end

    -- 将分隔符后的英文转大写，并移除分隔符
    text = text:gsub("[_%-%s]+(%w)", function(c)
        return string.upper(c)
    end)

    -- 每个英文单词首字母大写
    text = text:gsub("(%a)(%w*)", function(a, b)
        return string.upper(a) .. b
    end)

    -- 去掉残留空格
    text = text:gsub("%s+", "")

    return text
end

-- =========================
-- 候选词获取
-- =========================

local function get_selected_candidate_text(ctx)
    if not ctx then
        return nil
    end

    -- 常见方式
    if ctx.get_selected_candidate then
        local ok, cand = pcall(function()
            return ctx:get_selected_candidate()
        end)

        if ok and cand and cand.text then
            return cand.text
        end
    end

    -- 兜底方式：从 composition menu 里取当前高亮候选
    local comp = ctx.composition
    if comp and not comp:empty() then
        local segment = comp:back()
        if segment and segment.menu then
            local selected_index = segment.selected_index or 0
            local cand = segment.menu:get_candidate_at(selected_index)

            if cand and cand.text then
                return cand.text
            end
        end
    end

    return nil
end

-- =========================
-- 主处理函数
-- Tab 键提交翻译后的候选词
-- =========================

function M.func(key, env)
    -- 0xFF09 = Tab
    if key.keycode == 0xFF09 then
        local ctx = env.engine.context
        local cn = get_selected_candidate_text(ctx)

        if cn and cn ~= "" then
            local translated = translate(cn)

            -- 调试：记录每次 Tab 的输入输出
            append_debug("tab input=" .. tostring(cn) .. " | translated=" .. tostring(translated))

            -- 未知词记录不允许影响输出
            pcall(log_unknown_words, cn, translated)

            local en = toCamelCase(translated)

            if en and en ~= "" then
                env.engine:commit_text(en)
            else
                env.engine:commit_text(cn)
            end

            ctx:clear()
            return 1
        else
            append_debug("tab pressed but no candidate text")
        end
    end

    return 2
end

return M

