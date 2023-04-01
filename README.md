# vim-gpt
> Note: this plugin depends on [gpt][1]— an ergonomic CLI tool being set up.

This plugin brings OpenAI streaming chat completion API to Vim scratch buffers, & registers. In particular, when running `:Gpt [<reg>]` it opens a scratch buffer, if `g:gpt_default_register` is specified, the buffer will be populated using said register.

The scratch buffers created using `:Gpt` are visible in the buffers list, simplifying navigation and allowing to search through them and employ tools like [fzf][3].

Most important of all, there's a particular format for chat conversations that both [gpt][1] and vim-gpt follows:

```
You're a helpful assistant.

	>>>>>>
Tell a joke.

	<<<<<<
Sure, here's one: Why did the tomato turn red? Because it saw the salad dressing!

	>>>>>>
```

The system component may be skipped. Consider that if the guide marks are not provided, the whole buffer will be used as prompt, which may not be exactly what you're looking for. Using a dedicated register for the scratch template and the fact that [gpt][1] appends the prompting `>>>>>>` guide mark automatically, you are likely never going to write them by hand, although various binds/abbreviations may be employed to simplify.

The [gpt][1] tool may be configured to specifically write down all previous generations to separate files in some folder.

The `:GptDialog` command allows to choose the model (3, 4) and enter arbitrary number of parameters (see [gpt][1] for details) in a single `input()` prompt easily.

```vim
Plug 'tucnak/vim-gpt'

nnoremap <leader><leader> <Cmd>Gpt<CR>
inoremap <leader><leader> <Esc>:Gpt<CR>
let g:gpt_buffer_prefix = 'Chat'
let g:gpt_default_register = 'p'
let g:gpt_default_model = 3 " or 4
let g:gpt_default_opts = ''
let g:markdown_fenced_languages = [] "https://github.com/tpope/vim-markdown
augroup gpt_binds
	au FileType gpt nnoremap <buffer><silent> <Home> <Cmd>GptDefault<CR>
	au FileType gpt nnoremap <buffer><silent> <End> <Cmd>GptDialog<CR>
	au FileType gpt inoremap <buffer><silent> <Home> <Esc>:GptDefault<CR>
	au FileType gpt inoremap <buffer><silent> <End> <Esc>:GptDialog<CR>
augroup END
```

You can bind either `:GptDefault` or `:GptDialog` to whatever keys you want but I'm personally following my Keychron lifehack that I've come up with previously for Copilot, as pgup/pgdown/home/end keys are easily accessible and don't require any special kind of binds.

![][2]

### License

MIT

[1]: https://github.com/tucnak/gpt
[2]: https://i.redd.it/cuusrp3qgooa1.png
[3]: https://github.com/junegunn/fzf.vim
