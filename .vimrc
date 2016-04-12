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

" タブを空白入力に置き換える
set expandtab

" 検索結果をハイライト
set hlsearch

" dein
let s:dein_dir = expand('~/.vim/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

call dein#begin(s:dein_dir)
let s:toml = '~/.vim/rc/dein.toml'
let s:lazy_toml = '~/.vim/rc/dein_lazy.toml'

if dein#load_cache([expand('<sfile>'), s:toml, s:lazy_toml])
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})
  call dein#save_cache()
endif


call dein#end()

if dein#check_install()
  call dein#install()
endif

let g:indent_guides_enable_on_vim_startup = 1 " 起動時に発火

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

" for markdown file
au BufRead,BufNewFile *.md set filetype=markdown
let g:previm_open_cmd = 'open -a Firefox'

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
