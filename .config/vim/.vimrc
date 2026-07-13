filetype plugin indent on
syntax on

" set nu
set relativenumber

" Status line
set laststatus=2
set statusline=%F

" Always show the tab line at the top
set showtabline=2

" Quick navigations: Ctrl + Left/Right arrows to switch tabs
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>

" Alternative Quick navigations: Ctrl + H/L to switch tabs
nnoremap <C-h> :tabprevious<CR>
nnoremap <C-l> :tabnext<CR>

" Ensure terminal escape codes are set
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

function! ApplyItalics()
  " Core JavaScript / TSX Highlights
  highlight Comment cterm=italic gui=italic
  highlight Keyword cterm=italic gui=italic
  highlight Statement cterm=italic gui=italic
  highlight Conditional cterm=italic gui=italic
  highlight Repeat cterm=italic gui=italic
  
  " JavaScript/TypeScript Specifics (plugin-dependent)
  highlight jsStorageClass cterm=italic gui=italic
  highlight jsNull cterm=italic gui=italic
  highlight jsThis cterm=italic gui=italic
  highlight typescriptImport cterm=italic gui=italic
endfunction

" Automatically apply italics when opening files or changing colorschemes
augroup ItalicOverrides
  autocmd!
  autocmd ColorScheme,BufEnter,BufRead * call ApplyItalics()
augroup END

" Vim searches directories recursively
set path+=**

" Function to pass ripgrep & fzf output back into a native Vim tab
function! FzfOpenFileInNewTab()
  if executable('rg') && executable('fzf')
    " Use ripgrep to find files, stream to fzf menu, and catch selected item
    let l:command = "rg --files --hidden --smart-case --glob '!.git/*' | fzf --height 40% --layout=reverse"
    let l:filename = system(l:command)
    
    " Clean up terminal screen artifacts
    redraw!
    
    " If a file was selected (not canceled with ESC), open it in a new tab
    if !empty(l:filename)
      " Strip system trailing newline characters
      let l:cleaned_filename = substitute(l:filename, '\n$', '', '')
      execute 'tabedit ' . fnameescape(l:cleaned_filename)
    endif
  else
    echoerr "Error: 'rg' or 'fzf' system binaries are not installed."
  endif
endfunction

" Map Ctrl+P to run the plugin-free function in Normal mode
nnoremap <silent> <C-p> :call FzfOpenFileInNewTab()<CR>
