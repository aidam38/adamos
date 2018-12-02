" --------------------------------
" init.vim (.vimrc) of Adam Krivka
" --------------------------------
set encoding=utf-8
set clipboard=unnamed
set relativenumber
set hlsearch
set incsearch

" Pathogen plugin manager
execute pathogen#infect()
syntax on
filetype plugin on

" Colorscheme settings
"let g:solarized_termtrans = 1
"let g:solarized_termcolors = 256
"set background=dark
"colorscheme solarized

" Remember folds
augroup remember_folds
  autocmd!
  autocmd BufWinLeave * mkview
  autocmd BufWinEnter * silent! loadview
augroup END

" Some basic maps
noremap ů :
map <space> <leader>
noremap U <C-r> 
nnoremap <ESC> :noh<CR>:<CR>
nnoremap ú /

" Copy and paste maps
noremap <C-r> :reg<CR>
nnoremap  Y "+y
nnoremap  P "+p
vnoremap Y "+y
vnoremap P "+p
noremap x "_x

map <C-a> <esc>ggVG<CR>

" Movement maps
map j gj
map k gk
map J 10gj
map K 10gk
map H g0
map L g$

" Fold maps
noremap z za
noremap Z zf
noremap <C-z> zd

" Increment number
nnoremap <C-i> <C-a> "

inoremap <C-space> <Esc>i<Esc>/<++><Enter>"_c4l
map <leader><Tab> <Esc>/<++><Enter>"_c4l

" Filetype specific maps
" TeX
autocmd VimLeave *.tex !texclear %
autocmd filetype tex nnoremap <leader>l :w<CR>:!latexmk --pdf %<CR>
autocmd filetype tex nnoremap <leader>, :w<CR>:silent !pdflatex %<CR>
autocmd filetype tex nnoremap <leader>k :w<CR>:silent !zathura %:r.pdf & <CR>
autocmd filetype tex inoremap <C-e> }<ESC>yBi\end{<ESC>O\begin{<ESC>pa}
autocmd filetype tex nnoremap <leader>e ea}<ESC>bi\{<ESC>i
autocmd filetype tex inoremap <C-f> \frac{}{<++>}<ESC>6hi

" C++
autocmd filetype cpp nnoremap <leader>r :w<CR>:!g++ % -o torun && ./torun < 
