" -------------------- SET OPTIONS --------------------
set belloff=all
set showcmd

" no startup info text
set shortmess+=I
syntax on

set noswapfile

" placeholder chars for tabs and such
set listchars=tab:··,trail:·,leadmultispace:·
set list

" default is 8 chars which I don't need since I am 
" incapable of writing or understanding good code
set expandtab
set tabstop=4
set shiftwidth=4

set number relativenumber
set t_Co=256
set termguicolors

set clipboard=unnamedplus

" --- NOTE ---
"
" THE CLIPBOARD MAY NOT WORK UNLESS COMPILED WITH THE 
" --with-features=huge FLAG
" TO CHECK, USE
" :echo has('clipboard') 
" output = 0 means the clipboard feature is not available 
" output = 1 means it is available
"
" use this command in the root of the cloned repo 
" (remove the --without-x flag if you're using xorg)
"
" $ ./configure \                 
"	  --prefix=/usr \
"	  --with-features=huge \
"	  --enable-multibyte \
"	  --enable-terminal \
"	  --enable-cscope \
"	  --enable-clipboard \
"	  --without-x
"
" then use make build yada yada...


" guard for distributions lacking the 'persistent_undo' feature.
if has('persistent_undo')
    " define a path to store persistent undo files.
    let target_path = expand('~/.config/vim-persisted-undo/')    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call system('mkdir -p ' . target_path)
    endif    " point Vim to the defined undo directory.
    let &undodir = target_path    " finally, enable undo persistence.
    set undofile
endif

set laststatus=2
set noshowmode

function! CurrentMode()
  let l:mode = mode()
  if l:mode ==# 'n'
    return 'NORMAL'
  elseif l:mode ==# 'i'
    return 'INSERT'
  elseif l:mode ==# 'v'
    return 'VISUAL'
  elseif l:mode ==# 'V'
    return 'V-LINE'
  elseif l:mode ==# "\<C-v>"
    return 'V-BLOCK'
  elseif l:mode ==# 'R'
    return 'REPLACE'
  elseif l:mode ==# 'c'
    return 'COMMAND'
  else
    return l:mode
  endif
endfunction

set statusline=\ %{CurrentMode()}\ \|\ %f%m%r%h%w%=%l,%c\ %p%%\ 

" ----------------------- PLUGINS ---------------------

" NOTE: Install vim-plug only if you need these or some
" 		other plugins, else remove the entire plugin section

" PLUGINS LIST

	call plug#begin()

	Plug 'tpope/vim-sensible' " basic features idk
	Plug 'drsooch/gruber-darker-vim' " peak color scheme
	Plug 'neoclide/coc.nvim', {'branch': 'release'} " cock??
    Plug 'maxmellon/vim-jsx-pretty' " bitchass jsx

	call plug#end()
	
" PLUGIN OPTIONS

	" Setting the colorscheme
		augroup CustomHighlights
			autocmd!
			autocmd ColorScheme * highlight StatusLine ctermfg=254 ctermbg=240 cterm=none guifg=#e4e4ef guibg=#453d41 " Active statusline
			autocmd ColorScheme * highlight StatusLineNC ctermfg=246 ctermbg=235 cterm=none guifg=#95a99f guibg=#282828 " Inactive statusline
			autocmd ColorScheme * highlight LineNr ctermfg=243 guifg=#7c7c7c " change line numbers
			autocmd ColorScheme * highlight CursorLineNr ctermfg=221 guifg=#ffdd33 cterm=NONE gui=NONE " change current line number
			autocmd ColorScheme * highlight SpecialKey ctermfg=250 guifg=#362f32 " listchar color
			autocmd ColorScheme * highlight EndOfBuffer ctermfg=233 guifg=#181818 " squiggly thingy
			autocmd ColorScheme * highlight CursorLine ctermbg=235 guibg=#181818 cterm=NONE gui=NONE " current line highlight
            autocmd ColorScheme * highlight MatchParen guifg=#f4f4ff guibg=#9bb5ff ctermfg=255 ctermbg=111
		augroup END
		 colorscheme GruberDarker

	" CoC extensions
		let g:coc_global_extensions = ['coc-tsserver', 'coc-clangd']

	" PLUGINS REMAPS

	" GoTo code navigation (more cock)
		nmap <silent> gd <Plug>(coc-definition)
		nmap <silent> gy <Plug>(coc-type-definition)
		nmap <silent> gi <Plug>(coc-implementation)
		nmap <silent> gr <Plug>(coc-references)

" ---------------------- SCRIPTS ----------------------

" Set tabsize using :T num
" where num is the number of chars in tab
	command! -nargs=+ Tab call Tabs(<q-args>)
	function! Tabs(num)
	  execute 'set tabstop=' . a:num
	  execute 'set shiftwidth=' . a:num
	endfunction

" Git Diff in split pane
	function! ShowGitDiff()
	  " Open a new scratch buffer
	  new
	  setlocal buftype=nofile bufhidden=hide noswapfile
	  " Run git diff and load output
	  silent execute 'read !git diff'
	  " Remove empty first line
	  1delete _
	  setlocal nomodified
	  file [git-diff]
	endfunction
	command! GitDiff call ShowGitDiff()


" Use :R <command> to run said terminal command and get its output
" in new scratch buffer
	" Create the scratch directory if it doesn't exist
	if !isdirectory(expand('~/.vim/scratch'))
		call mkdir(expand('~/.vim/scratch'), 'p')
	endif
	command! -nargs=+ R call RunCommandInScratchBuffer(<q-args>)
	function! RunCommandInScratchBuffer(cmd)
		let scratch_file = expand('~/.vim/scratch/bufferfile')
		
		" Check if the scratch buffer is already open
		let bufnum = bufnr(scratch_file)
		if bufnum != -1
			" Buffer exists, switch to it
			silent execute 'buffer ' . bufnum
		else
			" Create new buffer with the scratch file
			silent execute 'edit ' . scratch_file
		endif
		
		" Clear the buffer and run the command
		silent %delete _
		silent execute 'read !' . a:cmd
		
		" Remove the empty first line that 'read' creates
		silent 1delete _
		
		" Go to the beginning of the buffer
		normal! gg
		
		" Save the file silently
		silent write
	endfunction
" ---------------------- REMAPS -----------------------

" Cycling between vim native buffers (check buffers using :buffers)
	nnoremap <S-l> :bn<CR>
	nnoremap <S-h> :bp<CR>

