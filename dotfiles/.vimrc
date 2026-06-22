" ==============================================================================
" VIM-PLUG ENGINE (IDE Extension Matrix)
" ==============================================================================
call plug#begin('~/.vim/plugged')

" File Explorer & Layouts
Plug 'preservim/nerdtree'                     " Sidebar file navigation
Plug 'vim-airline/vim-airline'               " Rich, IDE-status bar at the bottom
Plug 'vim-airline/vim-airline-themes'

" Code Intelligence & Auto-completion
Plug 'neoclide/coc.nvim', {'branch': 'release'} " VS-Code style IntelliSense/Autocomplete
Plug 'dense-analysis/ale'                     " Real-time linting and syntax check errors

" Git & Search Mastery
Plug 'tpope/vim-fugitive'                    " Git wrapper directly in the editor
Plug 'airblade/vim-gitgutter'                 " Shows +/- git changes next to line numbers
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Ultra-fast file finder
Plug 'junegunn/fzf.vim'

" Code Comfort
Plug 'tpope/vim-commentary'                  " Comment toggling shortcut
Plug 'jiangmiao/auto-pairs'                  " Automatic closing of brackets

" Color Themes
Plug 'arcticicestudio/nord-vim'               " Nord Theme
Plug 'ghifarit53/tokyonight-vim'              " Tokyo Night Theme
Plug 'drewtempelmeyer/palenight.vim'           " True Dark Blue Theme
Plug 'morhetz/gruvbox'                        " Gruvbox Theme

call plug#end()
" ==============================================================================
" CORE PREFERENCES & THEMES
" ==============================================================================
" Enable True Color support (CRITICAL for modern deep blue themes to look right!)
if (has("termguicolors"))
  set termguicolors
endif

" --- Pick ONE below by deleting the quote mark, comment out the others ---
colorscheme tokyonight
" colorscheme nord
" colorscheme palenight
" colorscheme gruvbox

syntax enable
" ==============================================================================
" CORE PREFERENCES & THEMES (Your Existing Foundational Setup)
" ==============================================================================
colorscheme badwolf
syntax enable

set tabstop=4                   " Visual space per TAB
set softtabstop=4               " Spaces entered when hitting TAB
set expandtab                   " Turns TAB into spaces
set number                      " Turns on line numbers
set showcmd                     " Show last command entered in bottom right
set cursorline                  " Highlights current line
set lazyredraw                  " Keeps vim from refreshing unnecessarily
set showmatch                   " Highlight matching brackets
set incsearch                   " Search as characters are entered
set hlsearch                    " Highlight matches

" ==============================================================================
" IDE NAVIGATION & UTILITY REMAPS
" ==============================================================================
" Clear search highlighting
nnoremap ,<space> :nohlsearch<CR>

" Toggle NERDTree sidebar with Ctrl+n
nnoremap <C-n> :NERDTreeToggle<CR>

" Project-wide fuzzy file finder with Ctrl+p
nnoremap <C-p> :Files<CR>

" Quick comment shortcut (gc to comment a line or selection)
" Handled natively by vim-commentary

" ==============================================================================
" CODE FOLDING CONFIGURATION (Your Existing Setup)
" ==============================================================================
set foldlevelstart=99           " Opens most folds by default
set foldnestmax=10              " 10 nested folds max
nnoremap <space> za             " Remaps spacebar to toggle fold
set foldmethod=syntax
let javaScript_fold = 1
let g:javaScript_fold = 1
let g:html_indent_inctags = "html,head,body,div,section,header,footer,nav,ul,ol,li"
let g:xml_syntax_folding = 1
autocmd FileType html setlocal foldmethod=indent
" ==============================================================================
" COMPONENT TUNING (ALE & Airline Options)
" ==============================================================================
let g:airline_powerline_fonts = 1
let g:ale_sign_column_always = 1 " Keeps the left gutter open so screen doesn't jitter on errors
