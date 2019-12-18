-- load standard vis module, providing parts of the Lua API
require('vis')

vis.events.subscribe(vis.events.INIT, function()
	-- Your global configuration options e.g.
	-- vis:command('map! normal j gj')
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	-- Your per window configuration options e.g.
	-- vis:command('set number')
	vis:command('set tabwidth 3')
	vis:command('set show-tabs on')
	vis:command('set rnu')
	vis:command('set cul')
	vis:command('set cc 80')
	vis:command('set theme grian')
end)
