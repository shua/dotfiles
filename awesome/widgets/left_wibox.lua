local wibox = require("wibox")
local awful = require("awful")
local common = require("awful.widget.common")


local lwibox = {}

lwibox.taglist = {
    buttons = awful.util.table.join(
        awful.button({}, 1, awful.tag.viewonly),
        awful.button({ modkey }, 1, awful.client.movetotag),
        awful.button({}, 3, awful.tag.viewtoggle),
        awful.button({ modkey }, 3, awful.client.toggletag),
        awful.button({}, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
        awful.button({}, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
    ),
    update_fun = function(w, buttons, label, data, objects)
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

--                l:fill_space(true)
--                l:add(ib)
--                l:add(m)
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
}

function lwibox.get(screen)
    screen = screen or 1
    if lwibox[screen] ~= nil then return lwibox[screen] end

    local cur = awful.wibox({ position="left", width="100", ontop=true, screen=screen })

    local layout = wibox.layout.fixed.vertical()
    local taglist = awful.widget.taglist(screen, 
        awful.widget.taglist.filter.all, 
        lwibox.taglist.buttons,
        nil,
        lwibox.taglist.update_fun,
        wibox.layout.flex.vertical())

    layout:add(taglist)

    cur:set_widget(layout)

    lwibox[screen] = cur

    return lwibox[screen]
end

return lwibox
