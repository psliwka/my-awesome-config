--- Various helper functions to be used in rc.lua
--
-- These are located in separate file mainly to reduce diff between my and stock
-- rc.lua, and thus simplify merging changes from the latter to the former.

local awful = require("awful")
local battery = require("awesome-upower-battery")

local helpers = {}

function helpers.show_app_selector()
    awful.spawn("rofi -show combi")
end

function helpers.run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        findme = cmd
        firstspace = cmd:find(" ")
        if firstspace then
            findme = cmd:sub(0, firstspace-1)
        end
        awful.spawn.with_shell(string.format("bash -c \"pgrep -u $USER -x %s > /dev/null || (%s)\"", findme, cmd))
    end
end

function helpers.mybattery()
    return battery({
        settings = function()
            widget:set_markup("Batt: " .. string.format("%3d", bat_now.perc) .. "% (" .. bat_now.status .. ")")
        end
    })
end

return helpers
