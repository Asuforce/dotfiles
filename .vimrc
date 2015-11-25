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
NeoBundle 'tpope/vim-fugitive' " Gitを使う
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'rstacruz/sparkup', {'rtp': 'vim/'}
NeoBundle 'tpope/vim-rails.git'
NeoBundle 'Townk/vim-autoclose'
NeoBundle 'vim-scripts/mru.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'nanotech/jellybeans.vim' " jellybeansカラースキーマ
NeoBundle 'scrooloose/nerdtree' " ファイルをtree表示
NeoBundle 'tpope/vim-rails' " Rails向けコマンドの提供
NeoBundle 'tpope/vim-endwise' " Ruby向けのend自動挿入
NeoBundle 'tomtom/tcomment_vim' " コメントのON/OFFを手軽に実現
NeoBundle 'nathanaelkane/vim-indent-guides' " インデントに色付け
let g:indent_guides_enable_on_vim_startup = 1 " 起動時に発火
NeoBundle 'vim-scripts/AnsiEsc.vim' " logファイルをカラーリング
NeoBundle 'bronson/vim-trailing-whitespace' " ホワイトスペースの可視化

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

" NERDTree関連
let NERDTreeShowHidden = 1
autocmd VimEnter * execute 'NERDTree'
nnoremap <silent><C-e> :NERDTreeToggle<CR> " nerdtreeを'ctrl + e'で起動

" タブページの管理
nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sn gt
nnoremap sp gT
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap sw <C-w>w
nnoremap so <C-w>_<C-w>|
nnoremap sO <C-w>=
nnoremap sN :<C-u>bn<CR>
nnoremap sP :<C-u>bp<CR>
nnoremap st :<C-u>tabnew<CR>
nnoremap sT :<C-u>Unite tab<CR>
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>
nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
nnoremap sB :<C-u>Unite buffer -buffer-name=file<CR>
