-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
require("awful.remote")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Vicious widgets
require("vicious")


-- {{{ ----------------------  Variable definitions  ---------------------------------
--
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/shua/.config/awesome/zenburn.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,		-- 1
    awful.layout.suit.tile,		-- 2
    awful.layout.suit.tile.left,	-- 3
    awful.layout.suit.tile.bottom,	-- 4
    awful.layout.suit.tile.top,		-- 5
    awful.layout.suit.fair,		-- 6
    awful.layout.suit.fair.horizontal,	-- 7
--    awful.layout.suit.spiral,		-- 8
--    awful.layout.suit.spiral.dwindle,	-- 9
    awful.layout.suit.max,		-- 10 -- 8
--    awful.layout.suit.max.fullscreen,	-- 11
--    awful.layout.suit.magnifier		-- 12
}
--
-- -------------------------------------------------------------------------------- }}}


-- {{{ ----------------------------  Tags  ----------------------------------------
-- Define a tag table which hold all screen tags.
tags = {
   -- names = { "1:Term", "2:Web", "3:Graphics", "4:Docs", "5:Sound", "6:Mail", "7:Games", "8:Extra" },
   names = { "✇", "⌥", "☕", "✍", "☼", "✉", "☠", "⌘" },
   layout = { layouts[6], layouts[8], layouts[7], layouts[8], layouts[5], layouts[5], layouts[8], layouts[2] }
}

for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- -------------------------------------------------------------------------------- }}}


-- {{{ ---------------------------  Menu  -----------------------------------------
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

menulauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- -------------------------------------------------------------------------------- }}}


-- {{{ --------------------   Keyboard widget  ------------------------------------
kbdlay = {}
kbdlay.layouts = {
   names = { "us-dv", "us-qw", "de-dv" },
   commands = { "setxkbmap us dvorak", "setxkbmap us", "setxkbmap de dvorak" }
}
kbdlay.current = 1
kbdlay.widget = widget({ type = "textbox" })
-- kbdlay.widget.text = "hello"
kbdlay.widget.text = kbdlay.layouts.names[kbdlay.current]
kbdlay.switch = function ()
  if kbdlay.layouts.names[kbdlay.current + 1] ~= nil then
    kbdlay.current = kbdlay.current + 1
    os.execute( kbdlay.layouts.commands[kbdlay.current] )
    kbdlay.widget.text = kbdlay.layouts.names[kbdlay.current]
  else
    kbdlay.current = 1
    os.execute( kbdlay.layouts.commands[kbdlay.current] )
    kbdlay.widget.text = kbdlay.layouts.names[kbdlay.current]
  end
end
-- -------------------------------------------------------------------------------- }}}


-- {{{ -----------------------  CPU widget ----------------------------------------
-- CPU usage and temperature
cpuicon = widget({ type = "imagebox" })
cpuicon.image = image(beautiful.widget_cpu)
-- Initialize widgets
cpugraph  = awful.widget.graph()
tzswidget = widget({ type = "textbox" })
-- Graph properties
cpugraph:set_width(40):set_height(18)
cpugraph:set_background_color(beautiful.fg_off_widget)
cpugraph:set_gradient_angle(0):set_gradient_colors({
   beautiful.fg_end_widget, beautiful.fg_center_widget, beautiful.fg_widget
}) -- Register widgets
vicious.register(cpugraph,  vicious.widgets.cpu,      "$1")
vicious.register(tzswidget, vicious.widgets.thermal, " $1°C", 5 , { "pci0000:00/0000:00:18.3" , "hwmon" } )
-- ------------------------------------------------------------------------------- }}}


-- {{{ --------------------  Memory usage  ---------------------------------------
memicon = widget({ type = "imagebox" })
memicon.image = image(beautiful.widget_mem)
-- Initialize widget
membar = awful.widget.progressbar()
-- Pogressbar properties
membar:set_vertical(true):set_ticks(true)
membar:set_height(18):set_width(8):set_ticks_size(2)
membar:set_background_color(beautiful.fg_off_widget)
membar:set_gradient_colors({ beautiful.fg_widget,
   beautiful.fg_center_widget, beautiful.fg_end_widget
}) -- Register widget
vicious.register(membar, vicious.widgets.mem, "$1", 13)
-- ------------------------------------------------------------------------------- }}}


-- {{{ ------------------------  Date and time  ----------------------------------
dateicon = widget({ type = "imagebox" })
dateicon.image = image(beautiful.widget_date)
-- Initialize widget
datewidget = widget({ type = "textbox" })
-- Register widget
vicious.register(datewidget, vicious.widgets.date, "%c")
-- Register buttons
-- datewidget:buttons(awful.util.table.join(
--   awful.button({ }, 1, function () exec("pylendar.py") end)
-- ))
-- ------------------------------------------------------------------------------- }}}


-- {{{ -----------------------------  Network  -----------------------------------
dnicon = widget({ type = "imagebox" })
upicon = widget({ type = "imagebox" })
dnicon.image = image(beautiful.widget_net)
upicon.image = image(beautiful.widget_netup)
-- Initialize widget
netwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(netwidget, vicious.widgets.net, '<span color="'
  .. beautiful.fg_netdn_widget ..'">${eth0 down_kb}</span> <span color="'
  .. beautiful.fg_netup_widget ..'">${eth0 up_kb}</span>', 3)
-- ------------------------------------------------------------------------------- }}}


-- {{{ -----------------------------  Other Widgets ------------------------------
-- Reusable separator
separator = widget({ type = "imagebox" })
separator.image = image(beautiful.widget_sep)
-- 

-- Pacman widget
pacicon = widget({type = "imagebox"})
pacicon.image = image(beautiful.widget_pacmn)
-- Initialize widget
pacwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(pacwidget, vicious.widgets.pkg, "Upgrades: $1", 10 ,  "Arch")

-- Create a textclock widget
textclock = awful.widget.textclock({ align = "right" })

-- Create a systray
systray = widget({ type = "systray" })
-- ------------------------------------------------------------------------------- }}}



-- /++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\
-- \++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/



-- {{{ -----------------------  Wibox  --------------------------------------------
-- Create a wibox for each screen and add it
topwibox = {}
bottomwibox = {}
promptbox = {}
layoutbox = {}
taglist = {}
taglist.buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
)
tasklist = {}
tasklist.buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
        if not c:isvisible() then
            awful.tag.viewonly(c:tags()[1])
        end
        client.focus = c
        c:raise()
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
)

for s = 1, screen.count() do
    promptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })

    layoutbox[s] = awful.widget.layoutbox(s)
    layoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
        awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
        awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    taglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, taglist.buttons)

    tasklist[s] = awful.widget.tasklist(function(c)
            return awful.widget.tasklist.label.currenttags(c, s)
        end, tasklist.buttons)


    topwibox[s] = awful.wibox({ position = "top", screen = s })
    topwibox[s].widgets = {
        {
            kbdlay.widget, separator,
            taglist[s], separator,
            promptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        layoutbox[s],
        -- textclock, separator,
        datewidget, dateicon, separator,
        s == 1 and systray or nil,
        membar.widget, memicon, separator,
        tzswidget, cpugraph.widget, cpuicon, separator,
	upicon, netwidget, dnicon, separator,
        pacwidget, pacicon, separator,
        layout = awful.widget.layout.horizontal.rightleft
    }

    bottomwibox[s] = awful.wibox({ position = "bottom", screen = s})
    bottomwibox[s].widgets = {
        menulauncher,
	tasklist[s],
	layout = awful.widget.layout.horizontal.leftright
    }
    bottomwibox[s].height = 5
end
-- ------------------------------------------------------------------------------------------------- }}}


-- {{{ -----------------------  Mouse bindings  -------------------------------------
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

kbdlay.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () kbdlay.switch() end)
))

-- --------------------------------------------------------------------------------- }}}


-- {{{ -----------------  Key bindings  -------------------------------------------
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:toggle(true)        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    awful.key({ modkey, "Control" }, "w", 
        function () 
            if bottomwibox[1].height == 5 then
                bottomwibox[1].height = 26
            else
                bottomwibox[1].height = 5
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({                   }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/Pictures/screenshots 2>/dev/null'") end),
    awful.key({                   }, "#171", function () awful.util.spawn("ncmpcpp next") end),
    awful.key({                   }, "#172", function () awful.util.spawn("ncmpcpp toggle") end),
    awful.key({                   }, "#173", function () awful.util.spawn("ncmpcpp prev") end),
    awful.key({                   }, "#174", function () awful.util.spawn("ncmpcpp stop") end),
    awful.key({                   }, "#123", function () awful.util.spawn("amixer -q sset Master 5+", false) end),
    awful.key({                   }, "#122", function () awful.util.spawn("amixer -q sset Master 5-", false) end),
    awful.key({                   }, "#121", function () awful.util.spawn("amixer -q sset Master toggle", false) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () promptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  promptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    
    -- Keyboard Layout
    awful.key({ modkey, "Control" }, "F1", function() kbdlay.switch() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- ------------------------------------------------------------------------------- }}}


-- {{{ -----------------  Rules  ---------------------------------------------
awful.rules.rules = {
-- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
--    { rule = { class = "MPlayer" },
--      properties = { floating = true } },
--    { rule = { class = "pinentry" },
--      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true,
                     tag = tags[1][3] } },
    { rule = { class = "pidgin" },
      properties = { tag = tags[1][6] } },
    { rule = { class = "skype" },
      properties = { tag = tags[1][6] } },

-- 2:Web tag stuff
    { rule = { class = "transmission" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "chromium" },
      properties = { tag = tags[1][2] } },

-- Wine stuff
    { rule = { class = "wineserver" },
      properties = { tag = tags[1][7] } },
    { rule = { class = "Steam.exe" },
      properties = { tag = tags[1][7] } },
    { rule = { class = "hl2.exe" },
      properties = { tag = tags[1][7] } }

    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- ----------------------------------------------------------------------- }}}


-- {{{ -------------------------  Signals  ------------------------------
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    c.size_hints_honor = false

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

-- {{{ ------------  Focus signal handlers  ------------------
client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- ----------------------------------------------------------- }}}


-- {{{ -------------------  Arrange signal handler  ----------
for s = 1, screen.count() do screen[s]:add_signal("arrange", function ()
    local clients = awful.client.visible(s)
    local layout = awful.layout.getname(awful.layout.get(s))

    for _, c in pairs(clients) do -- Floaters are always on top
        if   awful.client.floating.get(c) or layout == "floating"
        then if not c.fullscreen then c.above       =  true  end
        else                          c.above       =  false end
    end
  end)
end
-- ---------------------------------------------------------- }}}
-- ---------------------------------------------------------- }}}
