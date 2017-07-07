execute pathogen#infect()
call pathogen#helptags()

syntax on
filetype plugin indent on

set nocompatible
set t_Co=256
set nowrap                                 " Set no wrap text
set tabstop=4                              " Tab stop to 4 spaces
set smarttab                               " Do smart tab stops
set expandtab
set shiftwidth=4                           " Number of spaces for auto-indenting
set shiftround                             " Use multiple of shiftwidth when indenting with < and >
set backspace=indent,eol,start             " Allow backspacing over everything in insert mode
set autoindent                             " Set auto-indent on
set smartindent                            " Set smart-indent on
set copyindent                             " Copy indentation
set ignorecase                             " Ignore case while searching
set smartcase                              " Ignore case if search patter is all lowercase
set showcmd                                " Show (Partial) command in status line
set number                                 " Always show line numbers
set timeout timeoutlen=200 ttimeoutlen=100
set showmatch
set wildmenu
set visualbell                             " don't beep
set noerrorbells                           " don't beep
set autoread
set incsearch                              " Incremental search
set nohlsearch                             " Don't highlight search matches
set showmode                               " Shows helpful cues below the statusline
set laststatus=2                           " Force show bufferline
set encoding=utf-8
set relativenumber
set numberwidth=2
set cursorline
set hidden                                 " Allow switching away from a changed buffer without saving.

"set showtabline=2 "show tabline, 2 is always.

" finding Files:
set path+=**

colorscheme molokai
"colorscheme wwdc2016

highlight Search cterm=underline

" Auto-remove trailing spaces
autocmd BufWritePre *.php :%s/\s\+$//e

" Shortcuts
" =========

" Set Leader
let mapleader = ","
let g:mapleader = ","

" Underline current line with dashes
nnoremap <F5> yyp<c-v>$r=

" Insert newline and return to normal mode
nmap <C-o> o<Esc>

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Disable highlight when <leader><cr> is pressed
nnoremap <silent> <CR> :noh<CR><CR>

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?

" Substitue all occurences of the word under the cursor
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

" Open NERDTree
nmap <leader>e :NERDTree<cr>

" Fast saves
nmap <leader>w :w!<cr>
nmap <leader>q :q!<cr>
nmap <C-N><C-N> :set invnumber<CR>

" Fast Paste without indent
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

" Create new buffer
nmap <leader>t :enew<cr>

" Move to the next buffer
nmap <leader>l :bnext<cr>

" Move to the previous buffer
nmap <leader>h :bprevious<cr>

 if exists(":Tabularize")
    nmap <Leader>a= :Tabularize /=<CR>
    vmap <Leader>a= :Tabularize /=<CR>
    nmap <Leader>a: :Tabularize /:\zs<CR>
    vmap <Leader>a: :Tabularize /:\zs<CR>
endif

" NERDTree to open directories when vim is launched on a directory
if isdirectory(argv(0))
    bd  
    autocmd vimenter * exe "cd" argv(0)
    autocmd VimEnter * NERDTree
endif

" CtrlP Settings
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*.class,*.jar,*.xml

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}

let g:ctrlp_working_path_mode = 'r'

" Lightline Settings

"let g:lightline = {
"	\ 'tabline': {
"	\	'left': [ ['bufferline'] ]
"	\ },
"	\ 'component': {
"	\   'bufferline': '%{bufferline#refresh_status()}%{g:bufferline_status_info.before}%#TabLineSel#%{g:bufferline_status_info.current}%#LightLineLeft_active_3#%{g:bufferline_status_info.after}' 
"	\ }
"	\ }

"let g:lightline = {
"      \ 'tabline': {
"      \   'left': [ ['bufferline'] ]
"      \ },
"      \ 'component_expand': {
"      \   'bufferline': 'LightlineBufferline',
"      \ },
"      \ 'component_type': {
"      \   'bufferline': 'tabsel',
"      \ },
"      \ }
"
"function! LightlineBufferline()
"	call bufferline#refresh_status()
"	return [ g:bufferline_status_info.before, g:bufferline_status_info.current, g:bufferline_status_info.after]
"endfunction

" Bufferline settings

"let g:bufferline_modified = '*'
"let g:bufferline_active_buffer_left = ''
"let g:bufferline_active_buffer_right = ''
"let g:bufferline_show_bufnr = 0 
"let g:bufferline_solo_highlight = 0

" Airline Settings

"let g:airline_extensions=['bufferline', 'ctrlp', 'tabline']
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline_theme='powerlineish'
let g:airline_exclude_preview=1

" Goyo Settings
let g:goyo_width=110

command -nargs=+ Se execute 'vimgrep /' . [<f-args>][0] . '/ **/*.' . [<f-args>][1] | cw

" Search for current word and replace with given text for files in arglist.
function! Replace(bang, replace)
    let flag = 'ge'
    if !a:bang
    let flag .= 'c'
    endif
    let search = '\<' . escape(expand('<cword>'), '/\.*$^~[') . '\>'
    let replace = escape(a:replace, '/\&~')
    execute 'argdo %s/' . search . '/' . replace . '/' . flag
endfunction

command! -nargs=1 -bang Replace :call Replace(<bang>0, <q-args>)

nnoremap <Leader>r :call Replace(0, input('Replace '.expand('<cword>').' with: '))<CR>
