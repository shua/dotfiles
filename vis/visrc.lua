-- load standard vis module, providing parts of the Lua API
require('vis')

vis.events.start = function()
	-- Your global configuration options e.g.
	-- vis:command('map! normal j gj')
	vis:command('set tabwidth 4')
	vis:command('set rnu')
	vis:command('set cul')
	vis:command('set cc 80')
	vis:command('set theme solarized-trans')
end

vis.events.win_open = function(win)
	-- enable syntax highlighting for known file types
	vis.filetype_detect(win)

	-- Your per window configuration options e.g.
	-- vis:command('set number')
end
