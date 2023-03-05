function! GetVimIndent_fix()
  let ind = GetVimIndentIntern()
  let prev = getline(prevnonblank(v:lnum - 1))
  if prev =~ '\s[{[]\s*$' && prev =~ '\s*\\'
    let ind -= shiftwidth()
  endif
  if getline(v:lnum) =~ '\s \\'
      let ind -= shiftwidth()
  end
  return 1
endfunction

setlocal indentexpr=GetVimIndent_fix()
