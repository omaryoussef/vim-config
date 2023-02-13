" Measure startup time with:
" vim --startuptime vim.log
if !has("compatible")
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'godlygeek/tabular'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'Olical/vim-enmasse'
Plug 'vim-scripts/ZoomWin', { 'tag': '23' }
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-repeat'
Plug 'bkad/CamelCaseMotion'
Plug 'joshdick/onedark.vim'
Plug 'sbdchd/neoformat'
Plug 'arzg/vim-colors-xcode'
if executable("git")
Plug 'mhinz/vim-signify'
endif
call plug#end()
endif

if has("gui_running")
    set guifont=Meslo_LG_S:h10.4
    set t_vb=0
    set guicursor+=n-v-c-r:blinkon0
    set guioptions -=T
    set guioptions -=m
    set guioptions -=r
    set guioptions -=R
    set guioptions -=l
    set guioptions -=L
    autocmd GUIEnter * simalt ~x
endif

set t_Co=256                                " Enable 256 color mode.
set nocompatible                            " Enable vim mode.
set nowrap                                  " Set no wrap text
set tabstop=2                               " Tab stop to 4 spaces
set softtabstop=2
set smarttab                                " Do smart tab stops
set expandtab
set shiftwidth=2                            " Number of spaces for auto-indenting
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
"set visualbell                              " don't beep
set noerrorbells                            " don't beep
set autoread
set incsearch                               " Incremental search
set hlsearch                                " Highlight searches.
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
set undofile                                " Set persistent undo
set undodir=~/.vim/undodir                  " Set undo file directory

set background=dark
colorscheme xcodedark

" Fix slow syntax highlighting for TS files
set re=0

" Use ripgrep if available
if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Define Rg command
" Uses Rg if available, executes grepprg silently and works
" on <cword>
fun! s:RgSearch(txt)
    let ser = a:txt
    if(empty(ser))
        let ser = expand("<cword>")
    endif

    if executable("rg")
        execute "silent! grep! -i --no-ignore-parent -g '!*.min.*' " . ser
    else
        execute 'silent! grep! -irF ' . ser . " ."
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
command! -nargs=* -complete=file RgSearch :call s:RgSearch(<q-args>)

"hi Visual ctermbg=239
"hi VisualNOS ctermbg=242

" NERDTree to open directories when vim is launched on a directory
if isdirectory(argv(0))
    bd
    autocmd vimenter * exe "cd" argv(0)
    autocmd VimEnter * NERDTree
endif

set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*.class,*.jar,*.xml,*\\node_modules\\*,*\\vendor\\*,*.min.*

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


" Neoformat
let g:neoformat_try_node_exe = 1
"autocmd BufWritePre *.js Neoformat

" Airline Settings

"let g:airline_extensions=['bufferline', 'ctrlp', 'tabline']
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='wombat'
let g:airline_exclude_preview=1

" Goyo Settings
let g:goyo_width=120

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


function! ExecuteMacroOverVisualRange()
    echo "@".getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
endfunction

let g:signify_vcs_list = ['git']


"if has('patch-7.4.775')
"    set completeopt+=noinsert
"    let g:mucomplete#enable_auto_at_startup = 0
"    inoremap <expr> <c-e> mucomplete#popup_exit("\<c-e>")
"    inoremap <expr> <c-y> mucomplete#popup_exit("\<c-y>")
"    inoremap <expr>  <cr> mucomplete#popup_exit("\<cr>")
"endif

call camelcasemotion#CreateMotionMappings('<leader>')
"let g:polyglot_disabled = ['jsx']

let g:prettier#config#bracket_spacing = 'true'

if executable("boxes")
  command! -range ShellBox :call ShellBox()
  command! -range Box :call Box()

  function! Box()
    execute ":'<,'>!boxes -p h2v1"
  endfunction

  function! ShellBox()
    execute ":'<,'>!boxes -p h2v1 -d shell"
  endfunction
endif

" Shortcuts
" =========

" Set Leader
let mapleader = ","
let g:mapleader = ","

" Disable default mapping since we are overriding it with our command
nnoremap <silent> <F2> :call SwitchToWriteableBufferAndExec('Buffers')<CR>
xnoremap <silent> <F3> :'<,'>:w !pbcopy<CR><CR>

nnoremap <silent> <C-p> :call SwitchToWriteableBufferAndExec('GFiles')<CR>
nnoremap <silent> <C-g> :call SwitchToWriteableBufferAndExec('Files')<CR>
nnoremap <silent> <C-\> :call SwitchToWriteableBufferAndExec('Rg')<CR>

" Or use <Leader> Replace
nnoremap <Leader>r :call Replace(0, input('Replace '.expand('<cword>').' with: '))<CR>

" Use Q to repeat macro on visual lines
xnoremap Q :'<,'>:normal @q<CR>
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

" Global search
nnoremap \ :RgSearch<SPACE>

" Underline current line with dashes
nnoremap <F5> yyp<c-v>$r=

" Disable highlight when <leader><cr> is pressed
nnoremap <silent> <CR> :noh<CR><CR>

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?

" Substitue all occurences of the word under the cursor
nnoremap <Leader>b :%s/\<<C-r><C-w>\>/

" Open NERDTree
nmap <silent> <leader>n :NERDTreeToggle<cr>

" Fast saves
nnoremap <leader>s :w!<cr>
nnoremap <leader>q :q!<cr>
nnoremap <leader>f :w !sudo tee > /dev/null %<CR>
nnoremap <leader>k :bd<cr>
nnoremap <C-N><C-N> :set invnumber<CR>:set relativenumber!<CR>
nnoremap <F7> :set invpaste paste?<CR>
set pastetoggle=<F7>

nnoremap <leader>l :bnext<cr>
nnoremap <leader>h :bprevious<cr>
nnoremap <leader>t :enew<cr>

if exists(":Tabularize")
    nmap <Leader>a= :Tabularize /=<CR>
    vmap <Leader>a= :Tabularize /=<CR>
    nmap <Leader>a: :Tabularize /:\zs<CR>
    vmap <Leader>a: :Tabularize /:\zs<CR>
endif

nnoremap <silent> <leader>g :Goyo<CR>
