execute pathogen#infect()
call pathogen#helptags()

set background=dark
colorscheme civic

syntax on
filetype plugin indent on

set t_Co=256
set nocompatible
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
set showmatch                              " Show matching brackets
set wildmenu                               " visual autocomplete for command menu
set wildmode=list:longest,full
set wildignorecase
set visualbell                             " don't beep
set noerrorbells                           " don't beep
set autoread
set incsearch                              " Incremental search
set nohlsearch                             " Don't highlight search matches
set showmode                               " Shows helpful cues below the statusline
set laststatus=2                           " Force show bufferline
set encoding=utf-8
set relativenumber
set numberwidth=2                          " Width of the number line
set cursorline                             " Highlight current cursor line
set hidden                                 " Allow switching away from a changed buffer without saving.
set splitbelow                             " Set horizontal split below
set splitright                             " Set vertical split below
set shortmess=a

" Change backup and swap file directory.
set noswapfile
set nobackup

" finding Files:
set path+=**

set fillchars=""
highlight VertSplit ctermbg=234

highlight Search cterm=underline

hi Visual ctermbg=239
hi VisualNOS ctermbg=242

" Auto-remove trailing spaces
autocmd BufNewFile,BufRead *.json set ft=javascript
autocmd BufWritePre *.php :%s/\s\+$//e

" Shortcuts
" =========

" Set Leader
let mapleader = ","
let g:mapleader = ","

" Underline current line with dashes
nnoremap <F5> yyp<c-v>$r=

" Insert newline and return to normal mode
"nmap <C-o> o<Esc>

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
nmap <silent> <leader>e :NERDTree<cr>

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

let g:ctrlp_working_path_mode = '0'

" Use this function to prevent CtrlP opening files inside non-writeable 
" buffers, e.g. NERDTree
function! SwitchToWriteableBufferAndExec(command)
    let c = 0
    let wincount = winnr('$')
    " Don't open it here if current buffer is not writable (e.g. NERDTree)
    while !empty(getbufvar(+expand("<abuf>"), "&buftype")) && c < wincount
        exec 'wincmd w'
        let c = c + 1
    endwhile
    exec a:command
endfunction

" Disable default mapping since we are overriding it with our command
let g:ctrlp_map = ''
nnoremap <silent> <C-p> :call SwitchToWriteableBufferAndExec('CtrlP')<CR>
"nnoremap <silent> <C-l> :call SwitchToWriteableBufferAndExec('CtrlPMRUFiles')<CR>
nnoremap <silent> <F3> :call SwitchToWriteableBufferAndExec('CtrlPBuffer')<CR>

" Airline Settings

"let g:airline_extensions=['bufferline', 'ctrlp', 'tabline']
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline_theme='powerlineish'
let g:airline_exclude_preview=1

" Goyo Settings
let g:goyo_width=110

command -nargs=+ Se execute 'vimgrep /' . [<f-args>][0] . '/ **/*.' . [<f-args>][1] | cw

function StripTrailingWhitespace()
	if !&binary && &filetype != 'diff'
		normal mz
		normal Hmy
		%s/\s\+$//e
		normal 'yz<CR>
		normal `z
	endif
endfunction

command Strip :call StripTrailingWhitespace()

" Populate list with :args first.
" Search a word with / or *.
" Use :Replace to replace all occurences in arglist
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


" Or use <Leader> Replace
nnoremap <Leader>r :call Replace(0, input('Replace '.expand('<cword>').' with: '))<CR>
