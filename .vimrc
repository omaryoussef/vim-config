execute pathogen#infect()
call pathogen#helptags()

set background=dark
colorscheme Civic

if has("gui_running")
    set guifont=Meslo_LG_S:h10.4
    set t_vb=0
    set guicursor+=n-v-c:blinkon0
endif

syntax on
filetype plugin indent on

set t_Co=256                                " Enable 256 color mode.
set nocompatible                            " Enable vim mode.
set nowrap                                  " Set no wrap text
set tabstop=4                               " Tab stop to 4 spaces
set softtabstop=4
set smarttab                                " Do smart tab stops
set expandtab
set shiftwidth=4                            " Number of spaces for auto-indenting
set shiftround                              " Use multiple of shiftwidth when indenting with < and >
set backspace=indent,eol,start              " Allow backspacing over everything in insert mode
set autoindent                              " Set auto-indent on
set smartindent                             " Set smart-indent on
set copyindent                              " Copy indentation
set preserveindent                          " Preserve indentation
set ignorecase                              " Ignore case while searching
set smartcase                               " Ignore case if search patter is all lowercase
set showcmd                                 " Show (Partial) command in status line
set number                                  " Always show line numbers
set timeout timeoutlen=2000 ttimeoutlen=100
set showmatch                               " Show matching brackets
set wildmenu                                " visual autocomplete for command menu
set wildmode=list:longest,full
set wildignorecase
set visualbell                              " don't beep
set noerrorbells                            " don't beep
set autoread
set incsearch                               " Incremental search
set nohlsearch                              " Don't highlight searches.
set showmode                                " Shows helpful cues below the statusline
set laststatus=2                            " Force show bufferline
set encoding=utf-8
set relativenumber
set numberwidth=2                           " Width of the number line
set cursorline                              " Highlight current cursor line
set hidden                                  " Allow switching away from a changed buffer without saving.
set splitbelow                              " Set horizontal split below
set splitright                              " Set vertical split below
set shortmess=a
set gdefault                                " Global replace by default
set path+=**                                " finding Files:
set noswapfile
set nobackup

" Use ripgrep if available
if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Define Rg command
" Uses Rg if available, executes grepprg silently and works 
" on <cword>
fun! s:Rg(txt)
    let ser = a:txt
    if(empty(ser))
        let ser = expand("<cword>")
    endif

    if executable("rg")
        execute "silent! grep! -i --no-ignore-parent -g '!*.min.*'" ser
    else
        execute 'silent! grep! -irF' ser
    endif

    if len(getqflist())
        copen 
        redraw!
    else
        cclose
        redraw!
        echo "No match found for " . ser
    endif
endfun
command! -nargs=* -complete=file Rg :call s:Rg(<q-args>)

hi Visual ctermbg=239
hi VisualNOS ctermbg=242

" Shortcuts
" =========

" Set Leader
let mapleader = ","
let g:mapleader = ","

" Global search
nnoremap \ :Rg<SPACE>

" Underline current line with dashes
nnoremap <F5> yyp<c-v>$r=

" Disable highlight when <leader><cr> is pressed
nnoremap <silent> <CR> :noh<CR><CR>

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?

" Substitue all occurences of the word under the cursor
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

" Open NERDTree
nmap <silent> <leader>e :NERDTreeToggle<cr>

" Fast saves
nmap <leader>w :w!<cr>
nmap <leader>q :q!<cr>
nmap <C-N><C-N> :set invnumber<CR>
nnoremap <F6> :set invpaste paste?<CR>
set pastetoggle=<F6>

nmap <leader>l :bnext<cr>
nmap <leader>h :bprevious<cr>
nmap <leader>t :enew<cr>

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

set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*.class,*.jar,*.xml,*\\node_modules\\*,*\\vendor\\*,*.min.*

" CtrlP Settings
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site|node_modules|vendor)$',
            \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg|min|tags)$',
            \}

let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_extensions = ['tag', 'buffertags']
let g:ctrlp_map = ''
let g:ctrlp_root_markers = ['.ctrlp']

if(executable('rg'))
    let g:ctrlp_user_command = 'rg %s --files --no-ignore-parent --color=never --glob ""'
    let g:ctrlp_use_caching = 0
else
    let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard'] " Ignore files in .gitignore
endif

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
nnoremap <silent> <C-p> :call SwitchToWriteableBufferAndExec('CtrlP')<CR>
nnoremap <silent> <F2> :call SwitchToWriteableBufferAndExec('CtrlPBuffer')<CR>
nnoremap <silent> <F3> :call SwitchToWriteableBufferAndExec('CtrlPBufTag')<CR>
nnoremap <silent> <F4> :call SwitchToWriteableBufferAndExec('CtrlPTag')<CR>

" Airline Settings

"let g:airline_extensions=['bufferline', 'ctrlp', 'tabline']
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='powerlineish'
let g:airline_exclude_preview=1

" Goyo Settings
let g:goyo_width=110

function! StripTrailingWhitespace()
    if !&binary && &filetype != 'diff'
        normal mz
        normal Hmy
        %s/\s\+$//e
        normal 'yz<CR>
        normal `z
    endif
endfunction

command! Strip :call StripTrailingWhitespace()

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

" Use Q to repeat macro on visual lines
xnoremap Q :'<,'>:normal @q<CR>
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
