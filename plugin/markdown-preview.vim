
" File:         markdown-preview.vim
" Description:  vim plugin provides html preview of markdown files, see :help markdown-preview
" Maintainer:   Matthew Kitt <mk dot kitt at gmail dot com>>
" Version:      1.0.0
" Last Change:  2011 Jan, 29
" License:
" Copyright (c) 2011 by Matthew Kitt

" Permission is hereby granted, free of charge, to any person
" obtaining a copy of this software and associated documentation
" files (the 'Software'), to deal in the Software without
" restriction, including without limitation the rights to use,
" copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the
" Software is furnished to do so, subject to the following
" conditions:

" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software

" THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
" OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
" HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
" WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
" FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
" OTHER DEALINGS IN THE SOFTWARE

" Bail quickly when:
" - this plugin was already loaded or disabled
" - when 'compatible' is set
if (exists("g:loaded_markdownpreview") && g:loaded_markdownpreview) || &cp
  finish
endif
let g:loaded_markdownpreview = 1

" Scoot if the executable isn't installed
if !executable('markdown')
  finish
endif

" Globals (can be overriden in .vimrc)
" Location to save the temp html files
if !exists("g:MarkdownPreviewTMP")
  let g:MarkdownPreviewTMP = $HOME.'/.vim/bundle/markdown-preview.vim/tmp/'
endif

" Location of the default stylesheets (github and readable)
if !exists("g:MarkdownPreviewDefaultStyles")
  let g:MarkdownPreviewDefaultStyles = $HOME.'/.vim/bundle/markdown-preview.vim/stylesheets/'
endif

" If there is no user styles defined in .vimrc, set it to the tmp dir
if !exists("g:MarkdownPreviewUserStyles")
  let g:MarkdownPreviewUserStyles = g:MarkdownPreviewTMP
endif

" Theme used everyime there is a new .md file created
if !exists("g:MarkdownPreviewDefaultTheme")
  let g:MarkdownPreviewDefaultTheme = 'github'
endif

" Whether to always open a new window everyime a file is generated
if !exists("g:MarkdownPreviewAlwaysOpen")
  let g:MarkdownPreviewAlwaysOpen = 0
endif

" ------------------------------------------------------------------------------
"  Internal Utility functions for setting stylesheet information at startup
" ------------------------------------------------------------------------------

" Generate the html links for the style sheets if they exist in the directory
function! SetMDPStyleSheets(style_dir)
  let l:style_refs = ''
  let l:mapped = split(a:style_dir, "\n")
  for item in l:mapped
    if filereadable(item.'style.css')
      let l:style_refs .= '<link href="'.item.'style.css" rel="stylesheet" media="screen, projection" />'
    endif
    if filereadable(item.'print.css')
      let l:style_refs .= '<link href="'.item.'print.css" rel="stylesheet" media="print" />'
    endif
  endfor
  return l:style_refs
endfunction

" Generate the option names for the list menu for selecting a style sheet
function! SetMDPOptions(style_dir)
  let l:style_names = ''
  let l:mapped = split(a:style_dir, "\n")
  for item in l:mapped
    if filereadable(item.'style.css')
      let l:snap = split(item, "/")
      let l:sname = l:snap[len(l:snap)-1]
      let l:style_names .= '<option id="'.l:sname.'" value="' . l:sname . '">' . l:sname . '</option>'
    endif
  endfor
  return l:style_names
endfunction

" Save the default style sheets and option names
let s:default_styles = glob(g:MarkdownPreviewDefaultStyles.'*/')
let s:default_styles_sheets = SetMDPStyleSheets(s:default_styles)
let s:default_styles_names = SetMDPOptions(s:default_styles)

" Save the user style sheets and option names
let s:user_styles = glob(g:MarkdownPreviewUserStyles.'*/')
let s:user_styles_sheets = SetMDPStyleSheets(s:user_styles)
let s:user_styles_names = SetMDPOptions(s:user_styles)

" ------------------------------------------------------------------------------
"  Internal Utility functions for concatenating the html document on parsing
" ------------------------------------------------------------------------------

" Return the head of the HTML document
function! GetHTMLHead(title)
  let l:str = '<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"/>' .
            \ '<style>* {margin:0; padding:0;}</style>' .
            \ s:default_styles_sheets .
            \ s:user_styles_sheets .
            \ '<title>'.a:title.'</title>' .
            \ '</head>'
  return l:str
endfunction

" Return the header of the HTML document
function! GetHTMLHeader(title)
  let l:str = '<body id="theme" class="'.g:MarkdownPreviewDefaultTheme.'">' .
            \ '<div class="header">' .
            \ '<h2>'.a:title.'</h2>' .
            \ '<select id="selects" onchange="selectTheme(event);">' .
            \ '<optgroup label="Default Themes">' .
            \ s:default_styles_names .
            \ '</optgroup>' .
            \ '<optgroup label="User Themes">' .
            \ s:user_styles_names .
            \ '</optgroup>' .
            \ '</select>' .
            \ '</div>'
  return l:str
endfunction

" Return the body of the HTML document
function GetHTMLBody(mkd)
  let l:str = '<div class="wikistyle">' .
            \ a:mkd .
            \ '</div>'
  return l:str
endfunction

" Return the javascript for selecting drop downs, really missing heredoc
function! GetHTMLTail()
  let l:str = '<script language="javascript" type="text/javascript">' .
            \ 'var themeID = document.getElementById("theme"),' .
            \ 'selects = document.getElementById("selects"),' .
            \ 'theme = themeID.className;' .
            \ 'function setTheme(new_theme, auto_select) {' .
            \ 'theme = new_theme;' .
            \ 'if (auto_select) {' .
            \ 'document.getElementById(theme).selected = "selected";' .
            \ '}' .
            \ 'themeID.className = theme;' .
            \ 'window.location.href = window.location.pathname + "#" + theme;' .
            \ '}' .
            \ 'function selectTheme(e) {' .
            \ 'setTheme(e.target.value, false);' .
            \ '}' .
            \ '(function () {' .
            \ 'var hash = window.location.hash;' .
            \ 'if (hash) {' .
            \ 'theme = hash.substring(1, hash.length);' .
            \ '}' .
            \ 'setTheme(theme, true);' .
            \ '}());' .
            \ '</script>' .
            \ '</body>' .
            \ '</html>'
  return l:str
endfunction

" ------------------------------------------------------------------------------
"  Public API
" ------------------------------------------------------------------------------

" Main function for concatenating and generating a previewable html document
function! MarkdownPreview()
  let l:file_with_extension = expand('%')

  if (l:file_with_extension == '')
    let l:file_with_extension = 'Untitled.md'
  endif

  let l:file_name = fnamemodify(l:file_with_extension, ":t:r")
  let l:file_extension = fnamemodify(l:file_with_extension, ":e")

  " Bail if this isn't a markdown file and bark at the User
  if (l:file_extension !~ 'm*[kdown]')
    echo 'This file type is not supported for generating markdown files'
    finish
  endif

  let l:tmp_file = g:MarkdownPreviewTMP . l:file_name . '.html'
  let l:tmp_exists = filereadable(l:tmp_file)
  let l:converted = system('markdown '.l:file_with_extension)

  let l:output_html = GetHTMLHead(l:file_name.'.'.l:file_extension)
  let l:output_html .= GetHTMLHeader(l:file_name.'.'.l:file_extension)
  let l:output_html .= GetHTMLBody(l:converted)
  let l:output_html .= GetHTMLTail()

  silent! call writefile([l:output_html], l:tmp_file)

  if ((!l:tmp_exists || g:MarkdownPreviewAlwaysOpen == 1) && has("mac"))
    silent! execute '!open '.l:tmp_file
    " silent! redraw!
  endif
endfunction

" Clears out any tmp markdown files
function! ClearMarkdownPreview()
  if !empty(globpath(g:MarkdownPreviewTMP, "*"))
    silent! execute '!rm -r '.g:MarkdownPreviewTMP.'*'
  endif
  " silent! redraw!
endfunction

" Do it on load
call ClearMarkdownPreview()

:command! MDP :call MarkdownPreview()
:command! CMDP :call ClearMarkdownPreview()

