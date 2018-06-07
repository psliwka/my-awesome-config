local awful = require("awful")

local rofi = {}

function rofi.run_prompt()
    awful.spawn("rofi -show run")
end

function rofi.desktop_run_prompt()
    awful.spawn("rofi -show drun")
end

function rofi.find_client_prompt()
    awful.spawn("rofi -show window")
end

function rofi.combi_prompt()
    awful.spawn("rofi -show combi")
end

local function strip_newline(value)
    return value:gsub("\n", "")
end

function rofi.select_from_table_prompt(items, callback)
    local items_str = table.concat(items, "\n")
    local rofi_cmd = "rofi -dmenu -format 'd s'"
    local cmd = "echo '" .. items_str .. "' | " .. rofi_cmd  -- TODO: escape quotes
    local function rofi_finished(stdout, stderr, reason, exit_code)
        if exit_code ~= 0 then return end
        selected_pos, selected_str = strip_newline(stdout):match("^(%d+) (.+)$")
        selected_pos = tonumber(selected_pos)
        callback(selected_pos, selected_str)
    end
    awful.spawn.easy_async_with_shell(cmd, rofi_finished)
end

function rofi.select_tag_prompt(callback, callback_if_new)
    local s = awful.screen.focused()
    local tag_names = {}
    for i, t in ipairs(s.tags) do
        tag_names[i] = t.name
    end
    local function tag_selected(index, name)
        if index == 0 then
            callback_if_new(name)
        else
            callback(s.tags[index])
        end
    end
    rofi.select_from_table_prompt(tag_names, tag_selected)
end

function rofi.ask_for_tag_name(prompt, callback)
    local function rofi_finished(stdout, stderr, reason, exit_code)
        if exit_code ~= 0 then return end
        entered_name = stdout:gsub("\n", "")
        if #entered_name ~= 0 then
            callback(entered_name)
        end
    end
    awful.spawn.easy_async("rofi -dmenu -p '" .. prompt .. "'", rofi_finished)
end

return rofi
