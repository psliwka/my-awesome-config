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

function rofi.goto_tag_prompt()
    local tag_names = ""
    for _, tag in ipairs(awful.screen.focused().tags) do
        tag_names = tag_names .. tag.name .. "\n"
    end
    local rofi_invocation = "rofi -dmenu -no-custom -format d"
    local cmd = "echo \"" .. tag_names .. "\" | " .. rofi_invocation  -- TODO: escape quotes in tag names
    awful.spawn.easy_async_with_shell(cmd, function(stdout, stderr, reason, exit_code)
        local choosen_tag_index = tonumber(stdout)
        awful.screen.focused().tags[choosen_tag_index]:view_only()
    end)
end

return rofi
