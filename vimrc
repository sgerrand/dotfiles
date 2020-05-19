" --------------------------------------------------------
" General
" --------------------------------------------------------
set nocompatible			" be iMproved, required
set history=1000			" lots of command line history
set cf				" error files / jumping
set ffs=unix,dos,mac			" support these files
set isk+=_,$,@,%,#,-			" none word dividers
set viminfo='1000,f1,:100,@100,/20
set modeline				" make sure modeline support is enabled
set autoread				" reload files (no local changes only)
set tabpagemax=50			" open 50 tabs max

filetype off				" required

" --------------------------------------------------------
" Vundle
" --------------------------------------------------------
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" language support
Plugin 'elixir-lang/vim-elixir'
Plugin 'fatih/vim-go'
Plugin 'kchmck/vim-coffee-script'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-leiningen'
Plugin 'tpope/vim-salve'
Plugin 'venantius/vim-cljfmt'

" misc
Plugin 'jpalardy/vim-slime'
Plugin 'godlygeek/tabular'
Plugin 'kien/ctrlp.vim'
Plugin 'ngmy/vim-rubocop'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-projectionist'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-surround'

" --------------------------------------------------------
" Colours/Themes
" --------------------------------------------------------
Plugin 'stephenmckinney/vim-solarized-powerline'

call vundle#end()            " required
filetype plugin indent on    " required

syntax enable

if has('gui_running')
	set background=light
else
	set background=dark
endif

" If the Solarized palette is not installed/configured/recognized
"let g:solarized_termcolors=256
"let g:solarized_termtrans=1

colorscheme default

" --------------------------------------------------------
" Backups
" --------------------------------------------------------
set nobackup                           " do not keep backups after close
set nowritebackup                      " do not keep a backup while working
set noswapfile                         " don't keep swp files either
set backupdir=$HOME/.vim/backup        " store backups under ~/.vim/backup
set backupcopy=yes                     " keep attributes of original file
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*
set directory=~/.vim/swap,~/tmp,.      " keep swp files under ~/.vim/swap

" ----------------------------------------------------------------------------
" UI
" ----------------------------------------------------------------------------
set ruler                  " show the cursor position all the time
set noshowcmd              " don't display incomplete commands
set nolazyredraw           " turn off lazy redraw
set number                 " line numbers
set wildmenu               " turn on wild menu
set wildmode=list:longest,full
set ch=2                   " command line height
set backspace=2            " allow backspacing over everything in insert
mode
set whichwrap+=<,>,h,l,[,] " backspace and cursor keys wrap to
set shortmess=filtIoOA     " shorten messages
set report=0               " tell us about changes
set nostartofline          " don't jump to the start of line when scrolling

" ----------------------------------------------------------------------------
" Visual Cues
" ----------------------------------------------------------------------------
set showmatch              " brackets/braces that is
set mat=5                  " duration to show matching brace (1/10 sec)
set incsearch              " do incremental searching
set laststatus=2           " always show the status line
set ignorecase             " ignore case when searching
set nohlsearch             " don't highlight searches
set visualbell             " shut the fuck up

" ----------------------------------------------------------------------------
" Text Formatting
" ----------------------------------------------------------------------------
set autoindent             " automatic indent new lines
set smartindent            " be smart about it
set nowrap                 " do not wrap lines
set softtabstop=2          " yep, two
set shiftwidth=2           " ..
set tabstop=4
set expandtab              " expand tabs to spaces
set nosmarttab             " fuck tabs
set formatoptions+=n       " support for numbered/bullet lists
set textwidth=80           " wrap at 80 chars by default
set virtualedit=block      " allow virtual edit in visual block ..
