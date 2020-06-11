" Plugin:      https://github.com/hardcoreplayers/dashboard-nvim
" Description: A fancy start screen for Vim.
" Maintainer:  Glepnir <http://github.com/glepnir>

if exists('g:loaded_dashboard') || &cp
  finish
endif

let g:loaded_dashboard = 1

if !get(g:, 'dashboard_disable_at_vimenter') && (!has('nvim') || has('nvim-0.3.5'))
  " Only for Nvim v0.3.5+: https://github.com/neovim/neovim/issues/9885
  set shortmess+=I
endif

let s:home_dir = getenv('HOME')

" Options
let g:dashboard_version = '0.0.1'
let g:dashboard_executive = get(g:,'dashboard_default_executive','clap')
let g:session_directory = get(g:, 'session_directory',  s:home_dir . '/.cache/vim/session')
let g:session_enable = get(g:,'dashboard_enable_session',1)

augroup dashboard
  autocmd!
  autocmd VimEnter * nested call s:loaded_dashboard()
augroup END

function! s:loaded_dashboard() abort
  if !argc() && line2byte('$') == -1
    if !get(g:, 'dashboard_disable_at_vimenter')
      call dashboard#instance(1)
    endif
  endif
  autocmd! dashboard VimEnter
endfunction

if g:session_enable
  " Save and persist session
  command! -nargs=? -complete=customlist,sessions#session#session_list SessionSave
    \ call sessions#session#session_save(<q-args>)

  " Load and persist session
  command! -nargs=? -complete=customlist,sessions#session#session_list SessionLoad
    \ call sessions#session#session_load(<q-args>)

  " Save session on quit if one is loaded
  augroup plugin_sessions
    autocmd!
    " If session is loaded, write session file on quit
    autocmd VimLeavePre *
      \ if ! empty(v:this_session) && ! exists('g:SessionLoad')
      \ |   execute 'mksession! ' . fnameescape(v:this_session)
      \ | endif
  augroup END
endif

" vim: et sw=2 sts=2
