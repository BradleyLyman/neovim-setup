let &shell = has('win32') ? 'powershell' : 'pwsh'
let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
set shellquote= shellxquote=

call plug#begin("~/AppData/Local/nvim/plugged")
  Plug 'preservim/nerdtree'
  Plug 'overcache/NeoSolarized'
  Plug 'MunifTanjim/nui.nvim'
  Plug 'VonHeikemen/fine-cmdline.nvim'
  Plug 'echasnovski/mini.indentscope'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'fannheyward/telescope-coc.nvim'
  Plug 'nvim-lua/plenary.nvim'

  Plug 'godlygeek/tabular'

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

lua << EOF
require('mini.indentscope').setup({
  symbol = "╎",
})

require("telescope").setup({
  extensions = {
    coc = {
      theme = "ivy",
      prefer_locations = true,
    }
  }
})
require("telescope").load_extension('coc')
EOF


filetype on
filetype plugin on
filetype indent off

set termguicolors
set encoding=utf-8
scriptencoding utf-8
set hidden
set mouse=v
set clipboard+=unnamedplus
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
autocmd BufWritePre * :%s/\s\+$//e
autocmd BufWritePre * :retab
set ruler
set colorcolumn=80
set autoread
set number
set relativenumber
syntax enable
set signcolumn=number

set background=dark
colorscheme NeoSolarized

hi ColorColumn ctermbg=Black

let g:latex_to_unicode_tab = 0
let g:latex_to_unicode_auto = 0

let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='luna'

" ------------------
" -- Key Mappings --
" ------------------

let mapleader = ","
nmap <space> zz

nnoremap ; <cmd>FineCmdline<CR>
nnoremap : <cmd>FineCmdline<CR>

" buffer controls
nnoremap <leader>w <C-w>

" file controls
nnoremap <leader>n :bn<CR>
nnoremap <leader>p :bp<CR>
nnoremap <leader>d :bdelete<CR>

" terminal escape
tnoremap <Esc> <C-\><C-n>

nnoremap <leader>e :NERDTreeToggle<CR>


" --------------------- "
" -- Nerdtree Config -- "
" --------------------- "

let g:NERDTreeWinSize=75
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" --------------
" -- augroups --
" --------------

augroup gitcommit
    autocmd!
    autocmd FileType gitcommit :set colorcolumn=72
augroup end

augroup julia
  autocmd!
  autocmd FileType julia :set syntax=OFF
  autocmd FileType julia :set tabstop=4
  autocmd FileType julia :set shiftwidth=4
augroup end

augroup rust
  autocmd!
  autocmd FileType rust :set syntax=OFF
  autocmd FileType rust :set tabstop=4
  autocmd FileType rust :set shiftwidth=4
augroup end

" ----------------
" -- COC CONFIG --
" ----------------

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

nnoremap <leader>gh :call <SID>show_documentation()<CR>
nnoremap <silent> K :call <SID>show_documentation()<CR>
nmap <leader>f  <Plug>(coc-fix-current)
nmap <leader>rn <Plug>(coc-rename)

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
