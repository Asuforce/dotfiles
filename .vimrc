" エンコード
set encoding=utf-8
set fileencodings=iso2022-jp,utf-8,sjis,euc-jp

" コードの色分け
syntax on

" コマンドライン補完を便利に
set wildmenu

" タイプ途中のコマンドを画面最下位に表示
set showcmd

" オートインデント、改行、インサートモード開始直後にBackSpaceで削除
set backspace=indent,eol,start

" オートインデント
set autoindent

" オートインデント幅
set shiftwidth=4

" 画面最下位にルーラー
set ruler

" ステータスラインを常に表示
set laststatus=2

" 行番号
set number

" インデント
set tabstop=4

" ビジュアルベル
set visualbell

" タブを空白入力に置き換える
set expandtab

" 検索結果をハイライト
set hlsearch

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
NeoBundle 'Shougo/neomru.vim'
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
NeoBundle 'junegunn/vim-easy-align'
NeoBundle "ctrlpvim/ctrlp.vim"

" vim-scripts repos
NeoBundle 'L9'
NeoBundle 'FuzzyFinder'

NeoBundleCheck
call neobundle#end()

filetype plugin indent on
filetype indent on

" カラースキーマ
set t_Co=256
set background=dark
colorscheme jellybeans

" NERDTree
let NERDTreeShowHidden = 1
autocmd VimEnter * execute 'NERDTree'
nnoremap <silent><C-e> :NERDTreeToggle<CR> " nerdtreeを'ctrl + e'で起動

" Unite
let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable =1
let g:unite_source_file_mru_limit = 200
nnoremap <silent> ,uy :<C-u>Unite history/yank<CR>
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> ,uu :<C-u>Unite file_mru buffer<CR>

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
