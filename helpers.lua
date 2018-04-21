--- Various helper functions to be used in rc.lua
--
-- These are located in separate file mainly to reduce diff between my and stock
-- rc.lua, and thus simplify merging changes from the latter to the former.

local awful = require("awful")

local helpers = {}

function helpers.show_app_selector()
    awful.spawn("rofi -show combi")
end

return helpers
