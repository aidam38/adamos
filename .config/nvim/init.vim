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

" Tex-conceal
set conceallevel=2
let g:tex_conceal="abdgm"

" Goyo - focus
map <leader>f :Goyo<CR>:set linebreak<CR>

" Fuzzy finder
set rtp+=~/.fzf

" Colorscheme settings
let g:solarized_termtrans = 1
let g:solarized_termcolors = 256
set background=dark
colorscheme base16-classic-dark

" Fold settings
set foldmethod=marker
set foldmarker=\begin,\end
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
"noremap z za
"noremap Z zf
"noremap <C-z> zd

" Marking maps
noremap , `

" Increment number
nnoremap <C-i> <C-a>

" Placeholder replacement
inoremap <C-space> <Esc>i<Esc>/<++><Enter>"_c4l
map <C-space> <Esc>/<++><Enter>"_c4l

" Compiler
nnoremap <leader>c :w!<CR>:!compile <c-r>%<CR>
nnoremap <leader>C :w!<CR>:!st -e "compile <c-r>%<CR>"

" Filetype specific maps

" TeX
" Basic
autocmd VimLeave *.tex !texclear %
autocmd filetype tex nnoremap <leader>, :w<CR>:!pdflatex %<CR>
autocmd filetype tex nnoremap <leader>. :w<CR>:!pdflatex %<CR>:!asy %:r-*.asy<CR>:!pdflatex %<CR>
autocmd filetype tex nnoremap <leader>k :w<CR>:silent !zathura %:r.pdf & <CR>
" Snippets
autocmd filetype tex inoremap <C-e> }<ESC>yBi\end{<ESC>O\begin{<ESC>pa}
autocmd filetype tex inoremap §fr \frac{}{<++>}<ESC>6hi
autocmd filetype tex inoremap §sq \sqrt{}<ESC>i
autocmd filetype tex inoremap §eq \begin{equation*}<ESC>o\end{equation*}<ESC>O
autocmd filetype tex inoremap §al \begin{align*}<ESC>o\end{align*}<ESC>O
autocmd filetype tex inoremap §en \begin{enumerate}[label=\arabic*.]<ESC>o\end{enumerate}<ESC>O\item
autocmd filetype tex inoremap §bu \begin{itemize}<ESC>o\end{itemize}<ESC>O
autocmd filetype tex inoremap §fi \begin{figure}<ESC>o\end{figure}<ESC>O
autocmd filetype tex inoremap §us \usepackage{}<ESC>i
autocmd filetype tex inoremap §in \includegraphics[width=0.8\textwidth]{}<ESC>i
inoremap §D \documentclass[a4paper, 12pt]{article}<CR>\usepackage[margin=1in]{geometry}<CR><CR>\begin{document}<CR>\end{document}<ESC>O
autocmd filetype tex inoremap §it \item 
autocmd filetype tex inoremap §b \textbf{}<ESC>i
autocmd filetype tex inoremap §B \mathbf{}<ESC>i
autocmd filetype tex inoremap §k \textit{}<ESC>i
autocmd filetype tex inoremap §c \textsc{}<ESC>i
autocmd filetype tex inoremap §uv \enquote{}<ESC>i


" C++
autocmd filetype cpp nnoremap <leader>r :w<CR>:!g++ % -o torun && ./torun < 

" Under construction
autocmd filetype tex noremap C <ESC>zozcV:'<,'>folddoc s/^/%/<CR>zo:noh<CR>
