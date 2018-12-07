" --------------------------------
" init.vim (.vimrc) of Adam Krivka
" --------------------------------

" Fundamentals
set encoding=utf-8
set clipboard=unnamed
set number relativenumber
set cursorline

" Persistent undo
set undodir=/home/adam/.config/nvim/undodir
set undofile

" Better search
set hlsearch
set incsearch

" Autocompletion
set wildmode=longest,list,full

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Pathogen plugin manager
execute pathogen#infect()
syntax on
filetype plugin on

" Colorscheme settings
let g:solarized_termtrans = 1
let g:solarized_termcolors = 256
set background=dark
colorscheme base16-classic-dark

" Remember folds
set viewoptions-=options
autocmd BufWinLeave * mkview
autocmd BufWinEnter * silent! loadview

" Some basic maps
noremap ů :
map <space> <leader>
noremap U <C-r> 
nnoremap <ESC> :noh<CR>:<CR>
nnoremap ú /
map <C-s> <CR>:wq!<CR>
map <C-q> <CR>:q!<CR>

" Copy and paste maps
noremap <C-r> :reg<CR>
nnoremap  Y "+y
nnoremap  P "+p
vnoremap Y "+y
vnoremap P "+p
noremap x "_x

map <C-a> <esc>ggVG<CR>
nnoremap S :%s//g<Left><Left>

" Movement maps
noremap j gj
noremap k gk
noremap J 10gj
noremap K 10gk
noremap H g0
noremap L g$

" Folding maps
noremap z za
noremap Z zf
noremap <C-z> zd

" Marking maps
noremap <leader>g `

" Increment number
nnoremap <C-i> <C-a>

" Placeholder replacement
inoremap <C-space> <Esc>i<Esc>/<++><Enter>"_c4l
map <C-space> <Esc>/<++><Enter>"_c4l

" Goyo - focus
map <leader>f :Goyo<CR>:set linebreak<CR>

" Compiler
nnoremap <leader>c :w! \| :!compile <c-r>%<CR><CR>

" Filetype specific maps

" TeX
" Basic
autocmd VimLeave *.tex !texclear %
autocmd filetype tex nnoremap <leader>l :w<CR>:!latexmk --pdf %<CR>
autocmd filetype tex nnoremap <leader>, :w<CR>:silent !pdflatex %<CR>
autocmd filetype tex nnoremap <leader>k :w<CR>:silent !zathura %:r.pdf & <CR>
" Snippets
autocmd filetype tex inoremap <C-e> }<ESC>yBi\end{<ESC>O\begin{<ESC>pa}
autocmd filetype tex nnoremap <leader>e ea}<ESC>bi\{<ESC>i
autocmd filetype tex inoremap §f \frac{}{<++>}<ESC>6hi
autocmd filetype tex inoremap §eq \begin{equation*}<ESC>o\end{equation*}<ESC>O
autocmd filetype tex inoremap §al \begin{align*}<ESC>o\end{align*}<ESC>O
autocmd filetype tex inoremap §en \begin{enumerate}[label=\arabic*.]<ESC>o\end{enumerate}<ESC>O\item
autocmd filetype tex inoremap §it \begin{itemize}<ESC>o\end{itemize}<ESC>O

" C++
autocmd filetype cpp nnoremap <leader>r :w<CR>:!g++ % -o torun && ./torun < 
