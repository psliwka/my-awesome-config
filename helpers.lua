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

local function sorted_tag_index(screen, name)
    local i = 1
    while screen.tags[i] do
        if name < screen.tags[i].name then break end
        i = i + 1
    end
    return i
end

function helpers.create_tag(insert, move_client)
    awful.prompt.run {
        prompt       = "New tag name: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then return end
            new_tag = awful.tag.add(new_name, {
                screen = awful.screen.focused(),
                index  = sorted_tag_index(awful.screen.focused(), new_name),
                layout = awful.layout.layouts[1]
            })
            if move_client and client.focus then
                client.focus:tags({new_tag})
            end
            new_tag:view_only()
        end
    }
end

function helpers.rename_tag()
    local selected_tag = awful.screen.focused().selected_tag
    if not selected_tag then return end
    awful.prompt.run {
        prompt       = "New tag name: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then return end
            selected_tag.name = new_name
            selected_tag.index = sorted_tag_index(awful.screen.focused(), new_name)
        end
    }
end

function helpers.insert_tag()
    helpers.create_tag(true, false)
end

function helpers.append_tag()
    helpers.create_tag(false, false)
end

function helpers.insert_tag_with_client()
    helpers.create_tag(true, true)
end

function helpers.append_tag_with_client()
    helpers.create_tag(false, true)
end

function helpers.provision_screen(screen)
    if #screen.tags == 0 then
        awful.tag({ "*scratch*" }, screen, awful.layout.layouts[1])
    end
end

function helpers.close_selected_tags()
    for _, tag in pairs(awful.screen.focused().selected_tags) do
        tag:delete()
    end
    helpers.provision_screen(awful.screen.focused())
end

return helpers
