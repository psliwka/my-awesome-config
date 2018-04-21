--- Ugly hack to disable Awesome native notifications support
--
-- This module shadows builtin naughty module, to prevent it from hijacking
-- notification popups on D-Bus, so that an external notification daemon can
-- display them instead. The module also re-implements just enough naughty API
-- to handle notifications issued from rc.lua, and forward them to the bus.
--
-- See also: https://github.com/awesomeWM/awesome/issues/1285

local awful = require("awful")

local naughty = {}

naughty.config = { presets = { critical = 1 } }

function naughty.notify(args)
    awful.spawn(string.format("notify-send \"%s\" \"%s\"", args["title"], args["text"]))
end

return naughty
