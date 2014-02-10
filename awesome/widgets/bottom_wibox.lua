local wibox = require("wibox")
local awful = require("awful")
local common = require("awful.widget.common")
local dock = require("salty.dock")
local capi = { screen = screen,
               client = client }


local bwibox = {}

bwibox.tasklist = {
    buttons = awful.util.table.join(
        awful.button({ }, 1, function (c)
            if c == client.focus then
                c.minimized = true
            else
                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                if not c:isvisible() then
                awful.tag.viewonly(c:tags()[1])
            end
                -- This will also un-minimize
                -- the client, if needed
                client.focus = c
                c:raise()
            end
        end),
        awful.button({ }, 3, function ()
            if instance then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({ width=250 })
            end
        end),
        awful.button({ }, 4, function ()
            awful.client.focus.byidx(1)
            if client.focus then client.focus:raise() end
        end),
        awful.button({ }, 5, function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end)
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
                m = wibox.layout.margin(ib, 0, 0, 0, 8)
                l = wibox.layout.align.vertical()

--                l:fill_space(true)
                l:set_middle(m)
--                if o.minimized then
--                    l:set_top(m)
--                else
--                    l:set_bottom(m)
--                end

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
--            if not pcall(tb.set_markup, tb, text) then
--                tb:set_markup("<i>&lt;Invalid text&gt;</i>")
--            end
            if capi.client.focus == o then
                tb:set_text("^")
            else
                tb:set_text("_")
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

function bwibox.set_struts(wibox)
    wibox:struts{ left=0, right=0, bottom=0, top=0 }
end

function bwibox.get(screen)
    screen = screen or 1
    if bwibox[screen] ~= nil then return bwibox[screen] end

    local cur = dock({ height="50", ontop=true, screen=screen })
--    local set_struts = function() bwibox.set_struts(cur) end
--    cur:connect_signal("property::width", set_struts)
--    cur:connect_signal("property::height", set_struts)
--    cur:connect_signal("property::visible", set_struts)
--    set_struts()
    local layout = wibox.layout.fixed.horizontal()
    local tasklist = awful.widget.tasklist(
        screen, 
        awful.widget.tasklist.filter.currenttags, 
        bwibox.tasklist.buttons,
        nil,
        bwibox.tasklist.update_fun,
        wibox.layout.fixed.horizontal())

    layout:add(tasklist)

    cur:set_widget(layout)
    dock.set_widget(cur, layout)
    dock.set_floating(cur, true, screen)
    dock.shrink(cur, screen)

    bwibox[screen] = cur

    return bwibox[screen]
end

return bwibox
