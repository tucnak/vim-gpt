if !exists('g:gpt_buffer_prefix')
	let g:gpt_buffer_prefix = 'Chat'
endif
let s:tail = 0

fun! s:new_buffer() abort
	let s:tail += 1
	let name = g:gpt_buffer_prefix . s:tail
  	let buf = bufnr(name, 1)
  	call setbufvar(buf, '&filetype', 'gpt')
  	call setbufvar(buf, '&buftype', 'nofile')
  	call setbufvar(buf, '&bufhidden', 'hide')
  	call setbufvar(buf, '&swapfile', 0)
  	call setbufvar(buf, '&buflisted', 1)
	" open scratch_buf in the current window
	execute 'buffer' buf
endfun

fun! gpt#scratch(...) abort
	let tpl = get(g:, 'gpt_default_register', '')
	if a:0 > 0
		let tpl = a:1
	endif
	echo tpl
	call s:new_buffer()
	if l:tpl == ''
		" bring into insert position
		call feedkeys('i')
	else
		" insert the prompt template and bring to insert position
		call feedkeys('"' . tpl . 'VpGi')
	endif
endfun

fun! gpt#instant() abort
	let model = get(g:, 'gpt_default_model', '3')
	let opts = get(g:, 'gpt_default_opts', '')
	call gpt#job(model, opts)
endfun

fun! gpt#dialog() abort
  	let model = input('model [3,4]: ', '4')
  	let opts = input('[temperature max_length top_p fpen ppen]: ', '0.7 256')
	redraw
	call gpt#job(model, opts)
endfun

fun! gpt#job(model, opts) abort
  	let command = &shell . ' -c "gpt -vim -' . a:model . ' ' . a:opts . '"'
  	let job_options = {
        		\ 'noblock': 1,
        		\ 'in_io': 'buffer',
        		\ 'in_buf': bufnr('%'),
        		\ 'in_top': 1,
        		\ 'in_bot': line('$'),
        		\ 'out_io': 'buffer',
        		\ 'out_buf': bufnr('%'),
        		\ 'err_io': 'pipe',
        		\ 'err_cb': function('s:errcheck')
        		\ }
	let job_id = job_start(command, job_options)
	echomsg 'GPT-' . a:model . '...'
endfun

fun! s:errcheck(job, data)
    if !empty(a:data)
		echohl ErrorMsg
    	echomsg a:data
    	echohl None
		sleep 3000
    endif
endfun

command! -nargs=? Gpt call gpt#scratch(<f-args>)
command! GptDefault call gpt#instant()
command! GptDialog call gpt#dialog()
