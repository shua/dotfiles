local inb = require("salty.imagenbar")
local wibox_margin = require("wibox.layout.margin")
local awful = require("awful")
local vicious = require("vicious")
local naughty = require("naughty")
local ipairs = ipairs

local widget = inb.bottombar()
local wifiwidget = wibox_margin(widget, 2, 0, 2, 2)
wifiwidget.inb = widget
wifiwidget.interface = "wlp0s26u1u4i2"
wifiwidget.colors = {
    fg = "#cfae96"
}
wifiwidget.icons = {
    connected = "/usr/share/icons/Flattr/status/scalable/network-idle.svg",
    disconnected = "/usr/share/icons/Flattr/status/scalable/network-error.svg",
    working = "/usr/share/icons/Flattr/status/scalable/network-offline.svg"
}
wifiwidget.inb:set_image(wifiwidget.icons.connected)
wifiwidget.inb:set_color(wifiwidget.colors.fg)
wifiwidget.inb:set_ticks(4)
wifiwidget.inb:set_tick_margin(2)
wifiwidget.ssid = ""
wifiwidget.link = 0
wifiwidget.networks = {}

function wifiwidget:notify()
    local preset = {
        title = "Status: ",
        icon = self.icons.connected
    }

    if wifiwidget.link ~= 0 then
        preset.title = preset.title .. " Connected"
        preset.text = self.ssid .. " strength: " .. self.link .. "%"
    elseif #self.networks ~= 0 then
        preset.title = preset.title .. " Available"
        preset.text = ""
        for i, spot in ipairs(self.networks) do
            preset.text = preset.text .. spot.ssid .. " " .. spot.quality * 100 .. "%\n"
        end
        preset.icon = self.icons.working
    else
        preset.title = preset.title .. " Disconnected"
        preset.text = "wifi has been disconnected"
        preset.icon = self.icons.disconnected
    end
    naughty.notify({ preset = preset })
end

wifiwidget.tooltip = awful.tooltip({ objects = { wifiwidget } })

wifiwidget:buttons(awful.util.table.join(
    awful.button({}, 1, function() wifiwidget:notify() end)
))

local wifi_scan = function(interface)
    local networks = {}
    local f = io.popen("/usr/bin/iwlist " .. interface .. " scan 2>&1")
    local iw = f:read("*all")
    f:close()

    if iw == nil or string.find(iw, "unknown command") then
        return nil
    end

    local i = 1
    iw = string.match(iw, 'Cell(.+)')
    while iw ~= nil do
        local ssid, strength, max = string.match(iw, '.-ESSID:"(.-)".-Signal level=(%d-)/(%d-)%s+')
        if not (ssid == "" or ssid == nil) then
            networks[i] = { 
                ssid = ssid or "N/A", 
                quality = (strength / max)
            }
            i = i+1
        end
        iw = string.match(iw, 'Cell(.+)')
    end

    return networks
end

vicious.register(wifiwidget, vicious.widgets.wifi, function(widget, args)
    widget.link = args["{link}"] or 0
    if widget.ssid ~= args["{ssid}"] then
        widget.ssid = args["{ssid}"] or ""
        widget:notify()
    end
    if widget.ssid and widget.ssid ~= "N/A" then
        widget.inb:set_image(widget.icons.connected)
        widget.tooltip:set_text(widget.ssid .. " " .. widget.link)
    else
        widget.networks = wifi_scan(widget.interface)
        if #widget.networks ~= 0 then
            widget.inb:set_image(widget.icons.working)
            widget.tooltip:set_text(#widget.networks .. " networks found")
        else
            widget.inb:set_image(widget.icons.disconnected)
            widget.tooltip:set_text("no networks found")
        end
    end
    widget.inb:set_value(args["{sign}"] / 100)
end, 5, wifiwidget.interface)

return wifiwidget
