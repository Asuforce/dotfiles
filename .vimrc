" filetype on
filetype plugin indent on

" エンコード
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp

" コマンドライン補完を便利に
set wildmenu

" タイプ途中のコマンドを画面最下位に表示
set showcmd

" オートインデント、改行、インサートモード開始直後にBackSpaceで削除
set backspace=indent,eol,start

" オートインデント
set autoindent

" オートインデント幅
set shiftwidth=2

" 画面最下位にルーラー
set ruler

" ステータスラインを常に表示
set laststatus=2

" 行番号
set number

" インデント
set tabstop=2

" ビジュアルベル
set visualbell

" タブをスペースに置き換える
set expandtab

" 検索結果をハイライト
set hlsearch

" clipbord
set clipboard+=unnamed

" 検索で大文字と小文字の区別しない
set ignorecase

" 検索文字列に大小文字列が混在した場合、区別して検索
set smartcase

filetype plugin indent on
filetype indent on

" colorscheme
syntax on
color elflord

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
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap sw <C-w>w
nnoremap sO <C-w>=
nnoremap sN :<C-u>bn<CR>
nnoremap sP :<C-u>bp<CR>
nnoremap st :<C-u>tabnew<CR>
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>q<CR>

