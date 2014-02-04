
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Solorized Settings

syntax enable

"set background=dark

if has('gui_running')
    set background=light
else
    set background=dark
endif

colorscheme solarized

" solarized options
"|   256
let g:solarized_termcolors=   256       

"|   1
let g:solarized_termtrans =   0  

"|   1
let g:solarized_degrade   =   0         

"|   0
let g:solarized_bold      =   1         

"|   0
let g:solarized_underline =   1         

"|   0
let g:solarized_italic    =   1         


"|   "high" or "low"
let g:solarized_contrast  =   "normal"  


"|   "high" or "low"
let g:solarized_visibility=   "normal"  
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""