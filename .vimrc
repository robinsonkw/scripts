colorscheme badwolf
syntax enable
set tabstop=4               " number of visual space per TAB
set softtabstop=4           " number of spaces entere when editing and hitting TAB
set expandtab               " turns TAB into spaces
set number                  " turns on line numbers
" set showcmd               " show last command entered in the bottom right
set cursorline              " highlights or underlines current line where cursor is
set lazyredraw              " leads to faster macros as it keeps vim from refreshing when it doesn't need to
set showmatch               " highlight matching for ({[]}) characters
set incsearch               " search as characters are entered
set hlsearch                " highlight matches
nnoremap ,<space> :nohlsearch<CR>
" ^^ clears highlighting with the input of comma and space
set foldenable              " enables syntax folding
set foldlevelstart=10       " opens most folds by default
set foldnestmax=10          " 10 nested folds max
" nnoremap <space> za         " remaps space to za to enable opening/closing folds
set foldmethod=indent
