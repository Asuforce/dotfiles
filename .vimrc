" エンコード
set encoding=utf-8
set fileencodings=iso2022-jp,utf-8,sjis,euc-jp

" コードの色分け
syntax on

" コマンドライン補完を便利に
set wildmenu

" タイプ途中のコマンドを画面最下位に表示
set showcmd

" オートインデント、開業、インサートモード開始直後にBackSpaceで削除
set backspace=indent,eol,start

" オートインデント
set autoindent

" オートインデント幅2
set shiftwidth=2

" 画面最下位にルーラー
set ruler

" ステータスラインを常に表示
set laststatus=2

" 行番号
set number

" インデントをスペース2つ分に
set tabstop=2

" ビジュアルベル
set visualbell

" NeoBundle
set nocompatible               " be iMproved
filetype off                   " required!

if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim
endif
call neobundle#begin(expand('~/.vim/bundle/'))
let g:neobundle_default_git_protocol='https'

" let NeoBundle manage NeoBundle
NeoBundle 'Shougo/neobundle.vim'

" My Bundles here:
"
" original repos on github
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'rstacruz/sparkup', {'rtp': 'vim/'}
NeoBundle 'tpope/vim-rails.git'
NeoBundle 'Townk/vim-autoclose'
NeoBundle 'vim-scripts/mru.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'nanotech/jellybeans.vim'

" vim-scripts repos
NeoBundle 'L9'
NeoBundle 'FuzzyFinder'

NeoBundleCheck
call neobundle#end()

filetype plugin indent on
filetype indent on

" カラースキーマ
set t_Co=256
colorscheme jellybeans
