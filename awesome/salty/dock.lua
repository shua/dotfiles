---------------------------------------------------------------------------
-- @author Julien Danjou &lt;julien@danjou.info&gt;
-- @copyright 2009 Julien Danjou
-- @release v3.5.2
---------------------------------------------------------------------------

-- Grab environment we need
local capi =
{
    awesome = awesome,
    screen = screen,
    client = client
}
local setmetatable = setmetatable
local tostring = tostring
local ipairs = ipairs
local table = table
local error = error
local wibox = require("wibox")
local beautiful = require("beautiful")

--- Wibox module for awful.
-- This module allows you to easily create dock and attach them to the edge of
-- a screen.
-- salty.dock
local dock = { mt = {} }

-- Array of table with docks inside.
-- It's an array so it is ordered.
local docks = {}

--- Get a wibox position if it has been set, or return bottom.
-- @param wibox The wibox
-- @return The wibox position.
function dock.get_position(wibox)
    for _, wprop in ipairs(docks) do
        if wprop.wibox == wibox then
            return wprop.position
        end
    end
    return "bottom"
end

--- Get a wibox alignment if it has been set, or return center.
-- @param wibox The wibox
-- @return the wibox aligment
function dock.get_align(wibox)
    for _, wprop in ipairs(docks) do
        if wprop.wibox == wibox then
            return wprop.align
        end
    end
    return "center"
end

function dock.get_floating(wibox)
    for _, wprop in ipairs(docks) do
        if wprop.wibox == wibox then
            return wprop.floating
        end
    end
    return true
end

function dock.get_widget(wibox)
    for _, wprop in ipairs(docks) do
        if wprop.wibox == wibox then
            return wprop.widget
        end
    end
    return true
end

function dock.set_widget(wibox, widget)
    for _, wprop in ipairs(docks) do
        if wprop.wibox == wibox then
            if not wprop.update then
                wprop.update = function() dock.shrink(wprop.wibox, 1) end
            end
 
            if wprop.widget then
                wprop.widget:disconnect_signal("widget::updated", wprop.update)
            end

            wprop.widget = widget

            if widget then
                widget:connect_signal("widget::updated", wprop.update)
            end

            wprop.update()
            wprop.wibox:set_widget(widget)
            return
        end
    end
end

--- Put a wibox on a screen at this position.
-- @param wibox The wibox to attach.
-- @param position The position: top, bottom left or right.
-- @param screen If the wibox it not attached to a screen, specified on which
-- screen the position should be set.
function dock.set_position(wibox, position, screen)
    local area = capi.screen[screen].geometry

    -- The "length" of a wibox is always chosen to be the optimal size
    -- (non-floating).
    -- The "width" of a wibox is kept if it exists.
    if position == "right" then
        wibox.x = area.x + area.width - (wibox.width + 2 * wibox.border_width)
    elseif position == "left" then
        wibox.x = area.x
    elseif position == "bottom" then
        wibox.y = (area.y + area.height) - (wibox.height + 2 * wibox.border_width)
    elseif position == "top" then
        wibox.y = area.y
    end

    for _, wprop in ipairs(docks) do
        if wprop.wibox == wibox then
            wprop.position = position
            break
        end
    end
end

-- Reset all docks positions.
-- local function update_all_docks_position()
--     for _, wprop in ipairs(docks) do
--         dock.set_position(wprop.wibox, wprop.position, wprop.screen)
--     end
-- end

-- local function call_wibox_position_hook_on_prop_update(w)
--     update_all_docks_position()
-- end

local function wibox_update_strut(wibox)
    for _, wprop in ipairs(docks) do
        if wprop.wibox == wibox then
            if not wibox.visible or dock.get_floating(wibox) then
                wibox:struts { left = 0, right = 0, bottom = 0, top = 0 }
            elseif wprop.position == "top" then
                wibox:struts { left = 0, right = 0, bottom = 0, top = wibox.height + 2 * wibox.border_width }
            elseif wprop.position == "bottom" then
                wibox:struts { left = 0, right = 0, bottom = wibox.height + 2 * wibox.border_width, top = 0 }
            elseif wprop.position == "left" then
                wibox:struts { left = wibox.width + 2 * wibox.border_width, right = 0, bottom = 0, top = 0 }
            elseif wprop.position == "right" then
                wibox:struts { left = 0, right = wibox.width + 2 * wibox.border_width, bottom = 0, top = 0 }
            end
            break
        end
    end
end

--- Align a wibox.
-- @param wibox The wibox.
-- @param align The alignment: left, right or center.
-- @param screen If the wibox is not attached to any screen, you can specify the
-- screen where to align. Otherwise 1 is assumed.
function dock.set_align(wibox, align, screen)
    local position = dock.get_position(wibox)
    local area = capi.screen[screen].workarea

    if position == "bottom" or position == "top" then
        if align == "center" then
            wibox.x = area.x + (area.width - wibox.width - 2 * wibox.border_width) / 2
        elseif align == "right" then
            wibox.x = area.x + area.width - (wibox.width + 2 * wibox.border_width)
        elseif align == "left" then
            wibox.x = area.x
        end
    elseif position == "right" or position == "left" then
        if align == "center" then
            wibox.y = area.y + (area.height - wibox.height - 2 * wibox.border_width) / 2
        elseif align == "bottom" then
            wibox.y = area.y + area.height - (wibox.height + 2 * wibox.border_width)
        elseif align == "top" then
            wibox.y = area.y
        end
    end

    for _, wprop in ipairs(docks) do
        if wprop.wibox == wibox then
            wprop.align = align
            break
        end
    end

    -- Update struts regardless of changes
    wibox_update_strut(wibox)
end

function dock.set_floating(wibox, floating)
    for _, wprop in ipairs(docks) do
        if wprop.wibox == wibox then
            wprop.floating = floating
            break
        end
    end

    wibox_update_strut(wibox)
end

--- Attach a wibox to a screen.
-- If a wibox is attached, it will be automatically be moved when other docks
-- will be attached.
-- @param wibox The wibox to attach.
-- @param position The position of the wibox: top, bottom, left or right.
-- @param screen TODO, this seems to be unused
function dock.attach(wibox, position, screen)
    -- Store wibox as attached in a weak-valued table
    local wibox_prop_table
    -- Start from end since we sometimes remove items
    for i = #docks, 1, -1 do
        -- Since docks are stored as weak value, they can disappear.
        -- If they did, remove their entries
        if docks[i].wibox == nil then
            table.remove(docks, i)
        elseif docks[i].wibox == wibox then
            wibox_prop_table = docks[i]
            -- We could break here, but well, let's check if there is no other
            -- table with their docks been garbage collected.
        end
    end

    if not wibox_prop_table then
        table.insert(docks, setmetatable({ wibox = wibox, position = position, screen = screen }, { __mode = 'v' }))
    else
        wibox_prop_table.position = position
    end

    wibox:connect_signal("property::width", wibox_update_strut)
    wibox:connect_signal("property::height", wibox_update_strut)
    wibox:connect_signal("property::visible", wibox_update_strut)

--     wibox:connect_signal("property::width", call_wibox_position_hook_on_prop_update)
--     wibox:connect_signal("property::height", call_wibox_position_hook_on_prop_update)
--     wibox:connect_signal("property::visible", call_wibox_position_hook_on_prop_update)
--     wibox:connect_signal("property::border_width", call_wibox_position_hook_on_prop_update)
end

--- Stretch a wibox so it takes all screen width or height.
-- @param wibox The wibox.
-- @param screen The screen to stretch on, or the wibox screen.
function dock.stretch(wibox, screen)
    if screen then
        local position = dock.get_position(wibox)
        local area = capi.screen[screen].workarea
        if position == "right" or position == "left" then
            wibox.height = area.height - (2 * wibox.border_width)
            wibox.y = area.y
        else
            wibox.width = area.width - (2 * wibox.border_width)
            wibox.x = area.x
        end
    end
end

--- Fit a wibox so it takes up as much space as the widget needs
-- @param wibox The wibox.
-- @param screen The wibox screen
function dock.shrink(wibox, screen)
    if screen then
        local widget = dock.get_widget(wibox)
        if not widget then return end
        local position = dock.get_position(wibox)
        local align = dock.get_align(wibox)
        local area = capi.screen[screen].workarea
        local ww, wh
        if position == "right" or position == "left" then
            ww, wh = widget:fit(wibox.width, area.height - (2 * wibox.border_width))
            if wh <= 0 then wibox.height = 1 end
            if wibox.height == wh then return end
            wibox.height = wh
            if align == "center" then
                wibox.y = area.y + (area.height - wibox.height - 2 * wibox.border_width) / 2
            elseif align == "top" then
                wibox.y = area.y
            else
                wibox.y = area.y + area.height - wibox.height - 2 * wibox.border_width
            end
        else
            ww, wh = widget:fit(area.width - (2 * wibox.border_width), wibox.height)
            if ww <= 0 then ww = 1 end
            if wibox.width == ww then return end
            wibox.width = ww
            if align == "center" then
                wibox.x = area.x + (area.width - wibox.width - 2 * wibox.border_width) / 2
            elseif align == "left" then
                wibox.x = area.x
            else
                wibox.x = area.x + area.width - wibox.width - 2 * wibox.border_width
            end
        end
    end
end

--- Create a new wibox and attach it to a screen edge.
-- @see wibox
-- @param args A table with standard arguments to wibox() creator.
-- You can add also position key with value top, bottom, left or right.
-- You can also use width or height in % and set align to center, right or left, or top or bottom.
-- You can also set the screen key with a screen number to attach the wibox.
-- If not specified, 1 is assumed.
-- @return The wibox created.
function dock.new(arg)
    local arg = arg or {}
    local position = arg.position or "bottom"
    local align = arg.align or "center"
    local has_to_stretch = false 
    local screen = arg.screen or 1

    arg.type = arg.type or "dock"

    if position ~= "top" and position ~="bottom"
            and position ~= "left" and position ~= "right" then
        error("Invalid position in salty.dock(), you may only use"
            .. " 'top', 'bottom', 'left' and 'right'")
    end

    if position == "top" or position == "bottom" then
        if align ~= "center" and align ~= "right" and align ~= "left" then
            error("Invalid align in salty.dock(), you may only use"
                .. " 'center', 'right', or 'left' with a"
                .. " 'top' or 'bottom' position")
        end
    else
        if align ~= "center" and align ~= "top" and align ~= "bottom" then
            error("Invalid align in salty.dock(), you may only use"
                .. " 'center', 'top', or 'bottom' with a"
                .. " 'left' or 'right' position")
        end
    end

    -- Set default size
    if position == "left" or position == "right" then
        arg.width = arg.width or beautiful.get_font_height(arg.font) * 1.5
        if arg.height then
            has_to_stretch = false
            if arg.screen then
                local hp = tostring(arg.height):match("(%d+)%%")
                if hp then
                    arg.height = capi.screen[arg.screen].geometry.height * hp / 100
                end
            end
        end
    else
        arg.height = arg.height or beautiful.get_font_height(arg.font) * 1.5
        if arg.width then
            has_to_stretch = false
            if arg.screen then
                local wp = tostring(arg.width):match("(%d+)%%")
                if wp then
                    arg.width = capi.screen[arg.screen].geometry.width * wp / 100
                end
            end
        end
    end

    local w = wibox(arg)

    w.visible = true

    if arg.floating == nil then
        arg.floating = true
    end
    dock.set_floating(w, arg.floating)
    w.set_floating = function(arg)
        if not arg then return end
        dock.set_floating(w, arg)
    end

    dock.attach(w, position, screen)
    dock.set_position(w, position, screen)
    dock.set_align(w, align, screen)

    w.dock_set_widget = "yo"
    if has_to_stretch then
        dock.stretch(w, screen)
--        w.dock_set_widget = function(widget) w:set_widget(widget) end
    else
        dock.shrink(w, screen)
        local function update_wibox() dock.shrink(w, screen) end
--        w.dock_set_widget = function(widget)
--            if w.dock_widget then
--                w.dock_widget:disconnect_signal("widget::updated", update_wibox)
--            end

--            w.dock_widget = widget
--            if widget then
--                widget:connect_signal("widget::updated", update_wibox)
--            end

--            update_wibox()
--            w:set_widget(widget)
--        end
    end

    return w
end

-- local function update_docks_on_struts(c)
--     local struts = c:struts()
--     if struts.left ~= 0 or struts.right ~= 0
--        or struts.top ~= 0 or struts.bottom ~= 0 then
--         update_all_docks_position()
--     end
-- end

-- Hook registered to reset all docks position.
-- capi.client.connect_signal("property::struts", update_docks_on_struts)
-- capi.client.connect_signal("unmanage", update_docks_on_struts)

function dock.mt:__call(...)
    return dock.new(...)
end

return setmetatable(dock, dock.mt)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
