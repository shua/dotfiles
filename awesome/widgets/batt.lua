local inb = require("salty.imagenbar")
local awful = require("awful")
local vicious = require("vicious")
local naughty = require("naughty")
local wibox_margin = require("wibox.layout.margin")

local widget = inb.bottombar()
local battwidget = wibox_margin(widget, 2, 0, 2, 2)
battwidget.inb = widget
battwidget.device = "BAT1"
battwidget.colors = {
    urgent = "#ff5555",
    battery = "#dddddd",
    charging = "#999999"
}
battwidget.icons = {
    urgent = "/usr/share/icons/Flattr/status/scalable/system-devices-panel-alert.svg",
    charging = "/usr/share/icons/Flattr/status/scalable/system-devices-panel-information.svg",
    battery = "/usr/share/icons/Flattr/status/scalable/system-devices-panel.svg"
}

battwidget.inb:set_color(battwidget.colors.battery)
battwidget.tooltip = awful.tooltip({ objects = { battwidget } })

battwidget.pluggedin = true
battwidget.charge = 100
battwidget.levels = {
    high = 95,
    low = 10,
    critical = 6
}
battwidget.time = 0

function battwidget:notify()
    local preset = {
        title = "Battery ",
        text = "battery: " .. battwidget.charge .. "%, " .. battwidget.time .. " remaining.",
        icon = battwidget.icons.charging
    }

    if battwidget.charge <= battwidget.levels.low then
        if battwidget.charge <= battwidget.levels.critical then
            preset = naughty.config.presets.critical
            preset.title = "WARNING! Battery critically low!"
        else
            preset.title = "Warning: low battery"
        end
    elseif battwidget.pluggedin and battwidget.charge >= battwidget.levels.high then
        preset.title = preset.title .. "full"
        preset.text = "battery is full(" .. battwidget.charge .. "%) you may want to unplug to extend battery life"
    else
        if battwidget.pluggedin then
            preset.title = preset.title .. "charging"
        else
            preset.title = preset.title .. "discharging"
        end
    end

    if battwidget._notify ~= nil then
        battwidget._notify = naughty.notify({
            replaces_id = battwidget._notify.id,
            preset = preset
        })
    else
        battwidget._notify = naughty.notify({ preset = preset })
    end
end

battwidget:buttons(awful.util.table.join(
    awful.button({}, 1, function() battwidget:notify() end)
))

vicious.register(battwidget.inb, vicious.widgets.bat, function(widget, args)
    local flag = ((args[1] == "-") == battwidget.pluggedin)
    battwidget.debug = tostring(args[1] == "-")

    battwidget.time = args[3]
    battwidget.pluggedin = (args[1] ~= "-")
    if (battwidget.charge > battwidget.levels.critical
            and args[2] <= battwidget.levels.critical)
            or (battwidget.charge > battwidget.levels.low
            and args[2] <= battwidget.levels.low) then
        flag = true
        battwidget.debug = battwidget.debug .. " change"
        widget:set_color(battwidget.colors.urgent)
        widget:set_image(battwidget.icons.urgent)
    elseif battwidget.pluggedin then
        widget:set_color(battwidget.colors.charging)
        widget:set_image(battwidget.icons.charging)
    else
        widget:set_color(battwidget.colors.battery)
        widget:set_image(battwidget.icons.battery)
    end

    flag = flag or (battwidget.charge < battwidget.levels.high
                    and args[2] >= battwidget.levels.high)
    battwidget.debug = battwidget.debug .. tostring(flag)
    battwidget.charge = args[2]
    battwidget.tooltip:set_text(args[2] .. "% " .. args[3])
    if flag then battwidget:notify() end
    return args[2]
end, 5, battwidget.device)

return battwidget
