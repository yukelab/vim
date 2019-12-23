"======================================================================
"
" tools.vim - 
"
" Created by skywind on 2019/12/23
" Last Modified: 2019/12/23 21:22:46
"
"======================================================================

" vim: set noet fenc=utf-8 ff=unix sts=4 sw=4 ts=4 :


"----------------------------------------------------------------------
" list buffer ids
"----------------------------------------------------------------------
function! s:buffer_list()
    redir => buflist
    silent! ls
    redir END
    let bids = []
    for curline in split(buflist, '\n')
        if curline =~ '^\s*\d\+'
            let bid = str2nr(matchstr(curline, '^\s*\zs\d\+'))
            let bids += [bid]
        endif
    endfor
    return bids
endfunc


"----------------------------------------------------------------------
" locals
"----------------------------------------------------------------------
let s:keymaps = '123456789abcdefgimnopqrstuvwxyz'


"----------------------------------------------------------------------
" get content
"----------------------------------------------------------------------
function! quickui#tools#ui_buffers()
	let bids = s:buffer_list()
	let content = []
	let index = 0
	let current = -1
	let bufnr = bufnr()
	for bid in bids
		let key = (index < len(s:keymaps))? strpart(s:keymaps, index, 1) : ''
		let text = '[' . ((key == '')? ' ' : ('&' . key)) . "]\t"
		let text .= ''. bid . "\t"
		let name = fnamemodify(bufname(bid), ':p')
		let main = fnamemodify(name, ':t')
		let path = fnamemodify(name, ':h')
		let buftype = getbufvar(bid, '&buftype')
		if main == ''
			continue
		elseif buftype == 'nofile' || buftype == 'quickfix'
			continue
		endif
		let text = text . main . "\t" . path
		let item = [text, 'b ' . bid]
		let content += [item]
		if bid == bufnr()
			let current = index
		endif
		let index += 1
	endfor
	let opts = {'title': 'Switch Buffer', 'index':current, 'close':'button'}
	let opts.border = g:quickui#style#border
	" let opts.syntax = 'cpp'
	let maxheight = (&lines - 6) * 60 / 100
	if len(content) > maxheight
		let opts.h = maxheight
	endif
	call quickui#listbox#any(content, opts)
endfunc

