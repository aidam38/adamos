" --------------------------------
" init.vim (.vimrc) of Adam Krivka
" --------------------------------

let g:calendar_google_calendar = 1
" Fundamentals
set encoding=utf-8
set clipboard=unnamed
set number relativenumber
set cursorline
set path +=**

" Tabs
" set list lcs=tab:\|\ 
set fillchars+=vert:\| 
set fillchars+=fold:―
set listchars=tab:│\ ,extends:›,precedes:‹,nbsp:·,trail:·
set list

" Spelling 
set spelllang=cs,en

" Better search
set hlsearch
set incsearch

" Autocompletion
set wildmode=longest,list,full
set wildmenu

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Persistent undo
set undodir=/home/adam/.config/nvim/undodir
set undofile

" Folding settings
set foldmethod=marker
set foldmarker=\\begin,\\end

" Fold saving across sessions
autocmd BufWinLeave * mkview
"autocmd BufWinEnter * silent! loadview

" Pathogen plugin manager
execute pathogen#infect()
syntax on
filetype plugin indent on

" Tex-conceal
set conceallevel=2
let g:tex_conceal="abdgm"

" Colorscheme settings
set background=dark
" let g:solarized_termtrans = 1
" let g:solarized_termcolors = 256
" colorscheme solarized
let base16colorspace=256  " Access colors present in 256 colorspace
set termguicolors
colorscheme base16-solarized-dark

" Fuzzy finder
set rtp+=~/.fzf

" --------------------------------
" Some basic maps
noremap ů :
map <space> <leader>
noremap U <C-r> 
nnoremap <ESC> :noh<CR>:<CR>
nnoremap ú /
map <leader>s <CR>:wq!<CR>
map <leader>q <CR>:q!<CR>
map <C-e> :silent !st lf %:p:h<CR>
map - ;

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
" noremap H g0
" noremap L g$

" nowrap! map
noremap <leader>z :set nowrap!<cr>

" spelling maps
noremap = ]s

" Buffers
nnoremap H :w<CR>:bprev<CR>
nnoremap L :w<CR>:bnext<CR>

" Reload config
nnoremap R :so /home/adam/.config/nvim/init.vim<CR>

" Shortcutting split navigation, saving a keypress:
" map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
" map <C-l> <C-w>l

" Folding maps
noremap zz za
"noremap Z zf
"noremap <C-z> zd

" Marking maps
noremap , `

" ctags
nnoremap ; <c-]>

" Goyo - focus
map <leader>f :Goyo<CR>:set linebreak<CR>

" Increment number
nnoremap <C-i> <C-a>

" Placeholder replacement
inoremap <C-space> <Esc>i<Esc>/<++><Enter>"_c4l
map <C-space> <Esc>/<++><Enter>"_c4l

" Compiler
nnoremap <leader>c :w!<CR>:silent !compile <c-r>%<CR>
nnoremap <leader>C :w!<CR>:!compile <c-r>%<CR>

" Commenting

nmap # gcc
vmap # gc

" Filetype specific maps

" TeX
" Basic
autocmd VimLeave *.tex !texclear %
autocmd filetype tex nnoremap <leader>, :w<CR>:!pdflatex %<CR>
autocmd filetype tex nnoremap <leader>. :w<CR>:!pdflatex %<CR>:!asy %:r-*.asy<CR>:!pdflatex %<CR>
autocmd filetype tex nnoremap <leader>k :w<CR>:silent !zathura %:r.pdf & <CR>
autocmd filetype tex nnoremap <leader>w :w<CR>:!analysepdf.sh %:r.pdf<CR>
" Snippets
autocmd filetype tex inoremap <C-e> }<ESC>yBi\end{<ESC>O\begin{<ESC>pa}
autocmd filetype tex inoremap §fr \frac{}{<++>}<++><ESC>10hi
autocmd filetype tex inoremap §sq \sqrt{}<++><ESC>4hi
autocmd filetype tex inoremap §eq \begin{equation*}<ESC>o\end{equation*}<ESC>O
autocmd filetype tex inoremap §al \begin{align*}<ESC>o\end{align*}<ESC>O
autocmd filetype tex inoremap §en \begin{enumerate}[label=\arabic*.]<ESC>o\end{enumerate}<ESC>O\item
autocmd filetype tex inoremap §bu \begin{itemize}<ESC>o\end{itemize}<ESC>O
autocmd filetype tex inoremap §fi \begin{figure}<ESC>o\end{figure}<ESC>O
autocmd filetype tex inoremap §us \usepackage{}<ESC>i
autocmd filetype tex inoremap §in \includegraphics[width=0.8\textwidth]{}<ESC>i
autocmd filetype tex inoremap §<space> \{<++>}<++><esc>F\a
inoremap §D \documentclass[a4paper, 12pt]{article}<CR>\usepackage[czech]{babel}<CR>\usepackage[utf8]{inputenc}<CR>\usepackage[margin=1in]{geometry}<CR><CR>\begin{document}<CR>\end{document}<ESC>O

autocmd filetype tex inoremap §it \item 
autocmd filetype tex inoremap §b \textbf{}<ESC>i
autocmd filetype tex inoremap §B \mathbf{}<ESC>i
autocmd filetype tex inoremap §k \textit{}<ESC>i
autocmd filetype tex inoremap §c \textsc{}<ESC>i
autocmd filetype tex inoremap §uv \enquote{}<ESC>i
autocmd filetype tex inoremap §jd \,{\rm }<++><ESC>4hi
autocmd filetype tex inoremap §rm {\rm }<++><ESC>4hi
autocmd filetype tex vnoremap §la yslabel("$<ESC>pa$", <ESC>pa, );<ESC>hi

fun! DuplicateAndSurround(phrase,prefix_first,suffix_first,prefix_second,suffix_second,...)
	let name = ''
	if a:0==0
	  let line = getline('.')
	  call inputsave()
	  let name = input(a:phrase)
	  call inputrestore()
	else
	  let name=get(a:,1,0)
	endif
	let lineone=a:prefix_first .name.a:suffix_first
	let linetwo=a:prefix_second.name.a:suffix_second
	put =lineone
	put =linetwo
endfun!

fun! MakeEnv(...)
	if a:0>=1
	call DuplicateAndSurround('Enter environment name:','\begin{','}','\end{','}',get(a:,1,0))
	endif
	call DuplicateAndSurround('Enter environment name:','\begin{','}','\end{','}')
endfun!
inoremap <space><space>e <esc>:call MakeEnv()<CR><esc>O


" C
autocmd filetype c nnoremap <leader>C :w<CR>:!gcc % -lm -o %:r && ./%:r <
" C++
autocmd filetype cpp nnoremap <leader>C :w<CR>:!g++ % -o torun && ./torun < 

" Gnuplot
autocmd filetype gnuplot nnoremap <leader>k :w<CR>:silent !zathura %:r.eps & <CR>

" Under construction
autocmd filetype tex noremap C <ESC>zozcV:'<,'>folddoc s/^/%/<CR>zo:noh<CR>
