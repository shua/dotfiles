local capi = {
    screen = screen,
    client = client
}
local pcall = pcall
local ipairs = ipairs
local awful_tasklist = require("awful.widget.tasklist")
local client = require("awful.client")
local util = require("awful.util")
local common = require("awful.widget.common")
local wibox = require("wibox")
local beautiful = require("beautiful")


local tasklist = {}
local props = {}
local props_default = {
    style = { classlabel=true, tasklist_disable_icon=false }
}

local function get_prop(tasklist)
    for _, v in ipairs(props) do
        if v.tasklist == tasklist then
            return v
        end
    end
    return props_default
end

-- set style.classlabel to false, if you want the normal tasklist labeling
function tasklist.vertical(screen, filter, buttons, style, update, base)
    style = style or props_default.style
    if style == props_default.style then
        salty_debug = "yup"
        if style.tasklist_disable_icon == false then
            salty_debug = "aye"
        end
    else
        satly_debug = "nope"
    end
    local classlabel = style.classlabel or props_default.style.classlabel

    update = update or tasklist.vert_update
    base = base or tasklist.vert_base
    local tasklist = awful_tasklist(screen, filter, buttons, style, update, base)

    if classlabel then
        -- I'm doing it like this because awful.wibox does it like this...
        -- "it" refering to storing extra traits, like style info which is needed for
        --   my custom labeling
        local cur_props
        for i =#props, 1, -1 do
            if props[i].tasklist == nil then
                 table.remove(props, i)
            elseif props[i].tasklist == tasklist then
                cur_props = props[i]
            end
        end
        if not cur_props then
            table.insert(props, setmetatable({ tasklist = tasklist, style = style }, { __mode = 'v' }))
        else
            cur_props.style = style
        end
    end

    return tasklist
end

function tasklist.horizontal(screen, filter, buttons, style, update, base)
    style = style or props_default.style
    local classlabel = style.classlabel or props_default.style.classlabel
    local tasklist = awful_tasklist(screen, filter, buttons, style, update, base)

    if classlabel then
        -- I'm doing it like this because awful.wibox does it like this...
        -- "it" refering to storing extra traits, like style info which is needed for
        --   my custom labeling
        local cur_props
        for i =#props, 1, -1 do
            if props[i].tasklist == nil then
                 table.remove(props, i)
            elseif props[i].tasklist == tasklist then
                cur_props = props[i]
            end
        end
        if not cur_props then
            table.insert(props, setmetatable({ tasklist = tasklist, style = style }, { __mode = 'v' }))
        else
            cur_props.style = style
        end
    end

    return tasklist
end

function tasklist.vert_update(w, buttons, label, data, objects)
    w:reset()
    local wprop = get_prop(w)
    local classlabel = wprop.style.classlabel
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
            l = wibox.layout.fixed.vertical()

            l:fill_space(true)
            l:add(ib)
            l:add(m)

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
        if classlabel then
            text = tasklist.class_label(o, wprop.style)
        end
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

tasklist.vert_base = wibox.layout.fixed.vertical()

-- A lot from tasklist_label in awful.tasklist
--   changed to give back the client's class name
--   prettified
function tasklist.class_label(c, args)
    if not args then args = {} end
    local theme = beautiful.get()
    local fg_normal = args.fg_normal or theme.tasklist_fg_normal or theme.fg_normal
    local fg_focus = args.fg_focus or theme.tasklist_fg_focus or theme.fg_focus
    local fg_urgent = args.fg_urgent or theme.tasklist_fg_urgent or theme.fg_urgent
    local fg_minimize = args.fg_minimize or theme.tasklist_fg_minimize or theme.fg_minimize
    local font = args.font or theme.tasklist_font or theme.font or ""
    local text = "<span font_desc='" .. font .. "'>"
    local class = ""

    local sticky = args.sticky or theme.tasklist_sticky or "▪"
    local ontop = args.ontop or theme.tasklist_ontop or '⌃'
    local floating = args.floating or theme.tasklist_floating or '✈'
    local maximized_horizontal = args.maximized_horizontal or theme.tasklist_maximized_horizontal or '⬌'
    local maximized_vertical = args.maximized_vertical or theme.tasklist_maximized_vertical or '⬍'

    if not theme.tasklist_plain_task_name then
        if c.sticky then class = class .. sticky end
        if c.ontop then class = class .. ontop end
        if client.floating.get(c) then class = class .. floating end
        if c.maximized_horizontal then class = class .. maximized_horizontal end
        if c.maximized_vertical then class = class .. maximized_vertical end
    end

    if c.minimized then
        class = class .. "_" .. (util.escape(c.class) or util.escape("<untitled>"))
    else
        class = class .. (util.escape(c.class) or util.escape("<untitled>"))
    end
    if capi.client.focus == c then
        if fg_focus then
            text = text .. "<span color='"..util.color_strip_alpha(fg_focus).."'>"..class.."</span>"
        else
            text = text .. "<span color='"..util.color_strip_alpha(fg_normal).."'>"..class.."</span>"
        end
    elseif c.urgent and fg_urgent then
        text = text .. "<span color='"..util.color_strip_alpha(fg_urgent).."'>"..class.."</span>"
    elseif c.minimized and fg_minimize and bg_minimize then
        text = text .. "<span color='"..util.color_strip_alpha(fg_minimize).."'>"..class.."</span>"
    else
        text = text .. "<span color='"..util.color_strip_alpha(fg_normal).."'>"..class.."</span>"
    end
    text = text .. "</span>"
    return text
end

return tasklist
