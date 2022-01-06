set background=dark
hi clear
syntax reset
let g:colors_name="shuall"

"	*Comment	any comment

"	*Constant	any constant
"	 String		a string constant: "this is a string"
"	 Character	a character constant: 'c', '\n'
"	 Number		a number constant: 234, 0xff
"	 Boolean	a boolean constant: TRUE, false
"	 Float		a floating point constant: 2.3e10

"	*Identifier	any variable name
"	 Function	function name (also: methods for classes)

"	*Statement	any statement
"	 Conditional	if, then, else, endif, switch, etc.
"	 Repeat		for, do, while, etc.
"	 Label		case, default, etc.
"	 Operator	"sizeof", "+", "*", etc.
"	 Keyword	any other keyword
"	 Exception	try, catch, throw

"	*PreProc	generic Preprocessor
"	 Include	preprocessor #include
"	 Define		preprocessor #define
"	 Macro		same as Define
"	 PreCondit	preprocessor #if, #else, #endif, etc.

"	*Type		int, long, char, etc.
"	 StorageClass	static, register, volatile, etc.
"	 Structure	struct, union, enum, etc.
"	 Typedef	A typedef

"	*Special	any special symbol
"	 SpecialChar	special character in a constant
"	 Tag		you can use CTRL-] on this
"	 Delimiter	character that needs attention
"	 SpecialComment	special things inside a comment
"	 Debug		debugging statements

"	*Underlined	text that stands out, HTML links

"	*Ignore		left blank, hidden  |hl-Ignore|

"	*Error		any erroneous construct

"	*Todo		anything that needs extra attention; mostly the
"			keywords TODO FIXME and XXX

" standard
hi Comment        ctermfg=darkgrey
hi PreProc        ctermfg=darkgrey
hi Ignore         ctermfg=darkgrey
hi NonText        ctermfg=darkgrey
hi LineNr         ctermfg=darkgrey

hi Normal         ctermfg=grey     ctermbg=black cterm=NONE
hi Identifier     ctermfg=grey     cterm=NONE
hi Type           ctermfg=grey
hi Special        ctermfg=grey
hi Statement      ctermfg=grey     cterm=NONE
hi Todo           ctermfg=grey     ctermbg=black cterm=BOLD
hi Underlined     cterm=UNDERLINE

hi Constant       ctermfg=white

" other stuff
hi Error          ctermfg=darkred  ctermbg=black cterm=UNDERLINE

hi Search         ctermfg=yellow   ctermbg=black cterm=NONE
hi IncSearch      ctermfg=yellow   ctermbg=black cterm=NONE

hi Visual         ctermbg=white
hi Pmenu          ctermfg=black    ctermbg=grey   cterm=NONE
hi PmenuSel       ctermfg=black    ctermbg=yellow cterm=NONE


