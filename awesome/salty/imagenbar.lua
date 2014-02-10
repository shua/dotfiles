local base = require("wibox.layout.base")
local widget_base = require("wibox.widget.base")
local imagebox = require("wibox.widget.imagebox")
local progressbar = require("awful.widget.progressbar")
local surface = require("gears.surface")
local setmetatable = setmetatable
local pairs = pairs

local imagenbar = {}

function imagenbar:draw(wibox, cr, width, height)
    local ix, iy, iw, ih, bx, by, bw, bh

    if self.bar_pos == "bottom" then
        ix, iy = 0, 0
        iw, ih = width, height - self.thickness - self.margin
        iw, ih = base.fit_widget(self.image, iw, ih)
        bw, bh = width, self.thickness
        bx, by = 0, height - bh
    elseif self.bar_pos == "top" then
        ix, iy = 0, bh + self.margin
        iw, ih = width, height - self.thickness - self.margin
        iw, ih = base.fit_widget(self.image, iw, ih)
        bw, bh = width, self.thickness
        bx, by = 0, 0
    elseif self.bar_pos == "left" then
        ix, iy = bw + margin, 0
        iw, ih = width - self.thickness - self.margin, height
        iw, ih = base.fit_widget(self.image, iw, ih)
        bw, bh = self.thickness, height
        bx, by = 0, 0
    elseif self.bar_pos == "right" then
        ix, iy = 0, 0
        iw, ih = width - self.thickness - self.margin, height
        iw, ih = base.fit_widget(self.image, iw, ih)
        bw, bh = self.thickness, height
        bx, by = width - bw, 0
    end
    base.draw_widget(wibox, cr, self.image, ix, iy, iw, ih)
    if self.ticks then
        self.bar:set_ticks_gap(self.tick_margin)
        local tmargins = (self.ticks - 1) * self.tick_margin
        if self.bar_pos == "bottom" or self.bar_pos == "top" then
            self.bar:set_ticks_size(math.floor((bw - tmargins) / self.ticks))
        else
            self.bar:set_ticks_size(math.floor((bh - tmargins) / self.ticks))
        end
    end
    base.draw_widget(wibox, cr, self.bar, bx, by, bw, bh)
end

function imagenbar:set_image(image) return self.image:set_image(image) end

function imagenbar:set_margin(value) self.margin = value end
function imagenbar:set_thickness(value) self.thickness = value end
function imagenbar:set_ticks(value)
    if value == 1 or value == 0 then return end
    self.bar:set_ticks(true)
    self.ticks = value
    self.tick_margin = 1
end
function imagenbar:set_tick_margin(value) self.tick_margin = value end

function imagenbar:set_value(value) return self.bar:set_value(value) end 
function imagenbar:set_border_color(value) return self.bar:set_border_color(value) end 
function imagenbar:set_color(value) return self.bar:set_color(value) end 
function imagenbar:set_bg_color(value) return self.bar:set_background_color(value) end 
function imagenbar:set_max_value(value) return self.bar:set_max_value(value) end 

function imagenbar:fit(orig_width, orig_height)
    local width, height = orig_height, orig_height
    local max_width, max_height, _

    if self.bar_pos == "bottom" or self.bar_pos == "top" then
        max_width, _ = self.image:fit(width, height - self.margin - self.thickness)
        max_height = max_width + self.margin + self.thickness, height
    else
        _, max_height = self.image:fit(width - self.margin - self.thickness, height)
        max_width = max_height + self.margin + self.thickness
    end

    return max_width, max_height
end

local function get_widget(bar_pos)
    local ret = widget_base.make_widget()

    for k, v in pairs(imagenbar) do
        if type(v) == "function" then
            ret[k] = v
        end
    end

    ret.drawn = 0
    ret.bar_pos = bar_pos
    ret.image = imagebox()
    ret.bar = progressbar()
    ret._emit_updated = function()
        ret:emit_signal("widget::updated")
    end

    ret.image:connect_signal("widget::updated", ret._emit_updated)
    ret.bar:connect_signal("widget::updated", ret._emit_updated)

    if bar_pos == "right" or bar_pos == "left" then
        ret.bar:set_vertical(true)
    end
    ret:set_thickness(4)
    ret:set_margin(0)
    return ret
end

function imagenbar.topbar()
    return get_widget("top")
end

function imagenbar.bottombar()
    return get_widget("bottom")
end

function imagenbar.leftbar()
    return get_widget("left")
end

function imagenbar.rightbar()
    return get_widget("right")
end

return imagenbar
