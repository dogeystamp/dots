" compile doc on write
function LilypondWatch()
       vsp
       vertical resize 20
       exec 'terminal ' .. 'echo ' .. expand("%:") .. " | entr lilypond /_"
       exec "norm \<c-w>h"
endfunc

nnoremap <silent> <leader>fc :call LilypondWatch()<cr>
nnoremap <silent><leader>fr :silent exec "!zathura --fork " . expand("%:p:r") . ".pdf &"<cr>

let g:AutoPairs = {'(':')', '[':']', '{':'}','"':'"'}
