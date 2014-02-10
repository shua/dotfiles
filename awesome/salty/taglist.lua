local pcall = pcall
local awful_taglist = require("awful.widget.taglist")
local common = require("awful.widget.common")
local wibox = require("wibox")

local taglist = {}

function taglist.vertical(screen, filter, buttons, style, update, base)
    update = update or taglist.vert_update
    base = base or taglist.vert_base
    return awful_taglist(screen, filter, buttons, style, update, base)
end

function taglist.horizontal(screen, filter, buttons, style, update, base)
    return awful_taglist(screen, filter, buttons, style, update, base)
end

function taglist.vert_update(w, buttons, label, data, objects)
    w:reset()
    for i, o in ipairs(objects) do
        local cache = data[o]
        local ib, tb, bgb, m, l
        if cache then
            ib = cache.ib
            tb = cache.tb
            bgb = cache.bgb
            m = cache.m
        else
            ib = wibox.widget.imagebox()
            tb = wibox.widget.textbox()
            bgb = wibox.widget.background()
            m = wibox.layout.margin(tb, 4, 4)
            l = wibox.layout.align.horizontal()

            l:set_left(ib)
            l:set_middle(m)

            bgb:set_widget(l)
            bgb:buttons(common.create_buttons(buttons, o))

            data[o] = {
                ib = ib,
                tb = tb,
                bgb = bgb,
                m = m,
            }
        end

        local text, bg, bg_image, icon = label(o)
        if not pcall(tb.set_markup, tb, text) then
            tb:set_markup("<i>&lt;Invalid text&gt;</i>")
        end
        bgb:set_bg(bg)
        if type(bg_image) == "function" then
            bg_image = bg_image(tb,o,m,objects,l)
        end
        bgb:set_bgimage(bg_image)
        ib:set_image(icon)
        w:add(bgb)
    end
end

taglist.vert_base = wibox.layout.flex.vertical()

return taglist
