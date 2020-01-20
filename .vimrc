" Plugin Management
call plug#begin('~/.vim/plugged')
  Plug 'easymotion/vim-easymotion'
  Plug 'itchyny/lightline.vim'
  Plug 'junegunn/fzf.vim'
  Plug 'junegunn/vim-easy-align'
  Plug 'luochen1990/rainbow'
  Plug 'majutsushi/tagbar'
  Plug 'MaxMEllon/vim-jsx-pretty'
  Plug 'mengelbrecht/lightline-bufferline'
  Plug 'mhinz/vim-signify'
  Plug 'mtth/scratch.vim'
  Plug 'pangloss/vim-javascript'
  Plug 'prettier/vim-prettier'
  Plug 'ryanoasis/vim-devicons'
  Plug 'scrooloose/nerdtree'
  Plug 'severin-lemaignan/vim-minimap'
  Plug 'sickill/vim-monokai'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'
  Plug '/usr/local/opt/fzf'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug '907th/vim-auto-save'
call plug#end()

" Boilerplate stuff
set shell=/bin/zsh
set clipboard=unnamed   " use system clipboard
noswapfile              " no swap files

" Colors
colorscheme monokai     " use color scheme
syntax enable           " enable syntax processing

" UI Configuration
set number              " show line numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
filetype indent on      " load file type-specific indent files
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to
set showmatch           " highlight matching [{()}]
set colorcolumn=150     " line ruler
set ruler               " show helpful info in bottom bar
set mouse=a             " use da mouse
set nowrap              " don't wrap lines
set visualbell          " don't beep at me
set t_vb=               " don't flash beep at me
set laststatus=2        " always show the status bar (bottom)
set noshowmode          " hide the mode status under the status bar
set updatetime=100      " time vim waits after you stop typing
set showtabline=2       " always show the tab bar (top)
set guioptions-=e       " tab interface for tab bar
set hidden              " hide open buffers

" Folding Configuration
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level

" Font Configuration
set guifont=Source\ Code\ Pro\ for\ Powerline:h12
set encoding=UTF-8
scriptencoding UTF-8

" Mappings - Use sparingly
let mapleader = "\<Space>"

" Spaces/Tabs
set expandtab           " tabs are spaces
set tabstop=2           " number of visual spaces per TAB
set softtabstop=2       " number of spaces in tab when editing

" Spelling Configuration
set spell
hi clear SpellBad
hi SpellBad cterm=underline
hi SpellBad gui=undercurl

""""""""""""""""""""""""""
"         Plugins       "
""""""""""""""""""""""""""
" Enable Plugins
let g:auto_save=1
let g:rainbow_active=1

" Alignment Configuration
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Minimap Configuration
let g:minimap_highlight='Identifier'
let g:minimap_toggle='<leader>mt'

" NERDTree Configuration
let NERDTreeShowHidden=1
let g:NERDTreeStatusline='%#NonText#'
map <Leader>\ :NERDTreeToggle<CR>

" FZF Configuration
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:60%'), <bang>1 )

command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>, '--path-to-ignore ~/.ignore --hidden', fzf#vim#with_preview('right:60%'), <bang>0)

function! s:tags_sink(line)
  let parts = split(a:line, '\t\zs')
  let excmd = matchstr(parts[2:], '^.*\ze;"\t')
  execute 'silent e' parts[1][:-2]
  let [magic, &magic] = [&magic, 0]
  execute excmd
  let &magic = magic
endfunction

function! s:tags()
  if empty(tagfiles())
    echohl WarningMsg
    echom 'Preparing tags'
    echohl None
    call system('ctags -R')
  endif

  call fzf#run({
  \ 'source':  'cat '.join(map(tagfiles(), 'fnamemodify(v:val, ":S")')).
  \            '| grep -v -a ^!',
  \ 'options': '+m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index',
  \ 'down':    '40%',
  \ 'sink':    function('s:tags_sink')})
endfunction

command! Tags call s:tags()

function! s:align_lists(lists)
  let maxes = {}
  for list in a:lists
    let i = 0
    while i < len(list)
      let maxes[i] = max([get(maxes, i, 0), len(list[i])])
      let i += 1
    endwhile
  endfor
  for list in a:lists
    call map(list, "printf('%-'.maxes[v:key].'s', v:val)")
  endfor
  return a:lists
endfunction

function! s:btags_source()
  let lines = map(split(system(printf(
    \ 'ctags -f - --sort=no --excmd=number --language-force=%s %s',
    \ &filetype, expand('%:S'))), "\n"), 'split(v:val, "\t")')
  if v:shell_error
    throw 'failed to extract tags'
  endif
  return map(s:align_lists(lines), 'join(v:val, "\t")')
endfunction

function! s:btags_sink(line)
  execute split(a:line, "\t")[2]
endfunction

function! s:btags()
  try
    call fzf#run({
    \ 'source':  s:btags_source(),
    \ 'options': '+m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index',
    \ 'down':    '40%',
    \ 'sink':    function('s:btags_sink')})
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

command! BTags call s:btags()

function! s:line_handler(l)
  let keys = split(a:l, ':\t')
  exec 'buf' keys[0]
  exec keys[1]
  normal! ^zz
endfunction

function! s:buffer_lines()
  let res = []
  for b in filter(range(1, bufnr('$')), 'buflisted(v:val)')
    call extend(res, map(getbufline(b,0,"$"), 'b . ":\t" . (v:key + 1) . ":\t" . v:val '))
  endfor
  return res
endfunction

command! FZFLines call fzf#run({
\   'source':  <sid>buffer_lines(),
\   'sink':    function('<sid>line_handler'),
\   'options': '--extended --nth=3..',
\   'down':    '60%'
\})

" Lightline Configuration
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename'] ],
      \   'right': [ [ 'lineinfo' ], ['percent'], [ 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'StatusFugitive',
      \   'filename': 'StatusFilename',
      \   'mode': 'StatusMode'
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
      \ }

let g:lightline.mode_map = {
        \ 'n' : 'N',
        \ 'i' : 'I',
        \ 'R' : 'R',
        \ 'v' : 'V',
        \ 'V' : 'V',
        \ "\<C-v>": 'V',
        \ 's' : 'S',
        \ 'S' : 'S',
        \ "\<C-s>": 'S'
        \ }

let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}
let g:lightline#bufferline#filename_modifier = ':~'

function! FileModified()
  if &filetype == "help"
    return ""
  elseif &modified
    return "+"
  elseif &modifiable
    return ""
  else
    return ""
  endif
endfunction

function! StatusMode()
  let fname = expand('%:t')
  return fname =~ '__Tagbar__' ? "\xF0\x9F\xA4\x99" :
        \ fname =~ 'NERD_tree' ? "\xF0\x9F\xA4\x99" :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! StatusFilename()
  let fname = expand('%')
  return fname =~ '__Tagbar__' ? 'TAGS' :
        \  fname =~ 'NERD_tree' ? 'NERD' :
        \ fname =~ '__Scratch__' ? 'SCRATCH' :
        \ ('' != StatusReadonly() ? StatusReadonly() . ' ' : '') .  
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != FileModified() ? ' ' . FileModified() : '')
endfunction

function! StatusReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! StatusFugitive()
  if exists("*fugitive#head")
    let _ = fugitive#head()
    let fname = expand('%:t')
    return fname =~ '__Tagbar__' ? '' :
           \ fname =~ 'NERD_tree' ? '' : 
           \ fname =~ '__Scratch__' ? '' :
           \ strlen(_) ? "\ue0a0 "._ : ''
  endif
  return ''
endfunction

" Prettier Configuration
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
let g:prettier#quickfix_enabled = 0
let g:prettier#autoformat = 0
autocmd BufWritePre,TextChanged,InsertLeave *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync

" Tagbar
map <Leader>t :Tagbar<CR>
