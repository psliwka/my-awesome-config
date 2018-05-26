--- Various helper functions to be used in rc.lua
--
-- These are located in separate file mainly to reduce diff between my and stock
-- rc.lua, and thus simplify merging changes from the latter to the former.

local awful = require("awful")
local battery = require("upower-battery")

local helpers = {}

function helpers.mybattery()
    return battery({
        settings = function()
            widget:set_markup("Batt: " .. string.format("%3d", bat_now.perc) .. "% (" .. bat_now.status .. ")")
        end
    })
end

return helpers
