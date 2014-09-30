set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup

set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set showmatch           " highlight matching [{()}]
set number              " show line numbers
set expandtab           " tabs are spaces
set softtabstop=4       " number of spaces in tab when editing
set tabstop=4           " number of visual spaces per TAB
set lazyredraw          " redraw only when we need to.
syntax enable           " enable syntax processing

autocmd BufRead,BufNew *.md set filetype=markdown
