-- load standard vis module, providing parts of the Lua API
require('vis')
require('plugins/filetype')
require('plugins/textobject-lexer')

vis.events.subscribe(vis.events.INIT, function()
	-- Your global configuration options e.g.
	-- vis:command('map! normal j gj')
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	-- enable syntax highlighting for known file types
--	vis.filetype_detect(win)

	-- Your per window configuration options e.g.
	-- vis:command('set number')
	vis:command('set tabwidth 4')
	vis:command('set rnu')
	vis:command('set cul')
	vis:command('set cc 80')
	vis:command('set theme solarized')
end)
