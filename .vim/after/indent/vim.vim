" function! GetVimIndent_fix()
"   let ind = GetVimIndentIntern()
"   let prev = getline(prevnonblank(v:lnum - 1))
"   if prev =~ '\s[{[]\s*$' && prev =~ '\s*\\'
"     let ind -= shiftwidth()
"   endif
"   if getline(v:lnum) =~ '\s \\'
"       let ind -= shiftwidth()
"   end
"   return 1
" endfunction

" setlocal indentexpr=GetVimIndent_fix()


" let &l:indentexpr = 'GetVimVspecIndent(' . &l:indentexpr . ')'

" if exists('*GetVimVspecIndent')
"   finish
" endif

" function GetVimVspecIndent(base_indent)
"   let indent = a:base_indent

"   let base_lnum = prevnonblank(v:lnum - 1)
"   let line = getline(base_lnum)
"   if 0 <= match(line, '\(^\||\)\s*\(after\|before\|describe\|it\)\>')
"     let indent += &l:shiftwidth
"   endif

"   return indent
" endfunction
