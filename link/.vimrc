
"Solorized Settings

syntax enable

"set background=dark

if has('gui_running')
    set background=light
else
    set background=dark
endif

colorscheme solarized

"option name               default     optional
"------------------------------------------------
g:solarized_termcolors=   256       "|   256
g:solarized_termtrans =   0         "|   1
g:solarized_degrade   =   0         "|   1
g:solarized_bold      =   1         "|   0
g:solarized_underline =   1         "|   0
g:solarized_italic    =   1         "|   0
g:solarized_contrast  =   "normal"  "|   "high" or "low"
g:solarized_visibility=   "normal"  "|   "high" or "low"
"------------------------------------------------