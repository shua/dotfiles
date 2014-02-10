local inb = require("salty.imagenbar")
local naughty = require("naughty")
local wibox_margin = require("wibox.layout.margin")
local awful = require("awful")
local terminal = terminal

local widget = inb.bottombar()
local volwidget = wibox_margin(widget, 2, 0, 2, 2)
volwidget.channel = "Master"
volwidget.step = "2dB"
volwidget.colors = {
    unmute = "#aecf96",
    mute = "#ff5656"
}
volwidget.icons = {
    muted = "/usr/share/icons/Flattr/status/scalable/audio-volume-muted-panel.svg",
    min = "/usr/share/icons/Flattr/status/scalable/audio-volume-zero-panel.svg",
    low = "/usr/share/icons/Flattr/status/scalable/audio-volume-low-panel.svg",
    medium = "/usr/share/icons/Flattr/status/scalable/audio-volume-medium-panel.svg",
    high = "/usr/share/icons/Flattr/status/scalable/audio-volume-high-panel.svg"
}

volwidget.inb = widget
volwidget.inb:set_color(volwidget.colors.mute)
volwidget.inb:set_image(volwidget.icons.muted)
volwidget.inb:set_value(1)
volwidget.adjust = {
    raise = function()
        awful.util.spawn("amixer set " .. volwidget.channel .. " " .. volwidget.step .. "+")
        volwidget.update()
    end,
    lower = function()
        awful.util.spawn("amixer set " .. volwidget.channel .. " " .. volwidget.step .. "-")
        volwidget.update()
    end,
    mute = function()
        awful.util.spawn("amixer set " .. volwidget.channel .. " toggle")
        volwidget.update()
    end
}

volwidget:buttons(awful.util.table.join(
    awful.button({}, 1, function() awful.util.spawn(volwidget.mixer) end)
))

volwidget.tooltip = awful.tooltip({ objects = { volwidget } })
volwidget.level = 0
volwidget.muted = false
function volwidget.update()
    local f = io.popen("amixer get " .. volwidget.channel)
    local mixer = f:read("*all")
    f:close()

    local vol, mute = string.match(mixer, "([%d]+)%%.*%[([%l]*)")
    volwidget.debug = vol .. mute
    vol = vol or 0
    mute = mute or "off"

    volwidget.level = vol
    if mute == "off" then
        volwidget.muted = true
        volwidget.tooltip:set_text(" [Muted] ")
        volwidget.inb:set_color(volwidget.colors.mute)
        volwidget.inb:set_value(1)
        volwidget.inb:set_image(volwidget.icons.muted)
        return
    end

    volwidget.muted = false
    volwidget.tooltip:set_text(volwidget.channel .. ": " .. volwidget.level .. "%")
    volwidget.inb:set_color(volwidget.colors.unmute)
    volwidget.inb:set_value(volwidget.level / 100)
    local iconlevels = { volwidget.icons.min, volwidget.icons.low, volwidget.icons.medium, volwidget.icons.high }
    local l
    if volwidget.level == "0" then
        l = 1
    else
        l = math.floor(volwidget.level / 100 * (#iconlevels - 2)) + 2
    end
    volwidget.inb:set_image(iconlevels[l])
end

volwidget.update()

return volwidget
