# Key Mappings

```vim
  nmap <silent> [d <Plug>(coc-diagnostic-prev)
  nmap <silent> ]d <Plug>(coc-diagnostic-next)

  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)     # CocAction('jumpDefinition')
  nmap <silent> gy <Plug>(coc-type-definition) # CocAction('jumpTypeDefinition')
  nmap <silent> gi <Plug>(coc-implementation) # CocAction('jumpImplementation')
  nmap <silent> gr <Plug>(coc-references)
  nmap <Leader>ic :call CocAction('showIncomingCalls')

  " Code updates.
  nmap <Leader>rn <Plug>(coc-rename)         # CocAction('rename')
  nmap <Leader>ac <Plug>(coc-codeaction)
  nmap <Leader>qf <Plug>(coc-fix-current)

  nnoremap <Leader>f :Files<CR>
  nnoremap <nowait> <Leader>b :Buffers<CR>
  nnoremap <nowait> <C-g> :GFiles --cached --modified --others<CR>
  nnoremap <nowait> <Leader>g :GFiles --cached --modified --others<CR>
  nnoremap <nowait> <Leader>t :GGrep<CR>
  nnoremap <nowait> <Leader>s :CocList --interactive --auto-preview symbols<CR>
  nnoremap <Leader>h :History<CR>

  nnoremap <nowait> <C-p> :FzfSwitchProject<CR>
  nnoremap <nowait> <Leader>p :FzfSwitchProject<CR>

  nmap <M-]> <Plug>(copilot-next)
  nmap <M-[> <Plug>(copilot-previous)
```
