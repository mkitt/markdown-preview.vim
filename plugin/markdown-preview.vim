
" File:         markdown-preview.vim
" Description:  vim plugin that provides an html preview of markdown files, see :help markdown-preview
" Maintainer:   Matthew Kitt <mk dot kitt at gmail dot com>>
" Version:      1.0.0
" Last Change:  2010 Oct, 09
" License:
" Copyright (c) 2010 by Matthew Kitt

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
"

" Globals (can be overriden in .vimrc)
" Location to save the temp html files
if !exists("g:MarkdownPreviewTMP")
  let g:MarkdownPreviewTMP = $HOME.'/.vim/bundle/markdown-preview.vim/tmp/'
endif

" Location of the default stylesheets (github and colorblind)
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

function! ClearMarkdownPreview()
  if !empty(globpath(g:MarkdownPreviewTMP, "*"))
    silent execute '!rm -r '.g:MarkdownPreviewTMP.'*'
  endif
endfunction

call ClearMarkdownPreview()

function! MarkdownPreview()
ruby << EOF
  require 'rubygems'
  require 'bluecloth'

  VIM::Buffer.current.name.nil? ? (name = 'Untitled.md') : (name = Vim::Buffer.current.name)
  file_name = name.gsub(/.(md|mkd|markdown)$/, '.html')

  if file_name == VIM::Buffer.current.name
    VIM::message('This file type is not supported for previewing markdown files')
    exit
  end

  always_open = VIM::evaluate('g:MarkdownPreviewAlwaysOpen')
  tmp_file = VIM::evaluate('g:MarkdownPreviewTMP') +  File.basename(file_name)
  tmp_exists = File.exists?(tmp_file)
  default_styles = Dir.glob(File.join(VIM::evaluate('g:MarkdownPreviewDefaultStyles'), '*'))
  user_styles = Dir.glob(File.join(VIM::evaluate('g:MarkdownPreviewUserStyles'), '*'))
  css_namespace = VIM::evaluate('g:MarkdownPreviewDefaultTheme')
  t = ""

  def set_stylesheets(style_dir)
    style_refs = ''
    style_dir.each do |style_ref|
      if File.exists?(style_ref + '/style.css')
        style_refs += '<link href="' + style_ref + '/style.css' + '"rel="stylesheet" media="screen, projection, print" />'
      end
      if File.exists?(style_ref + '/print.css')
        style_refs += '<link href="' + style_ref + '/print.css' + '"rel="stylesheet" media="print" />'
      end
    end
    return style_refs
  end

  def set_options(style_dir, ns)
    style_names = ''
    style_dir.each do |style_name|
      if File.exists?( style_name + '/style.css')
        s_name = File.basename(style_name)
        style_names += '<option id="' + s_name + '" value="' + s_name + '">' + s_name + '</option>'
      end
    end
    return style_names
  end

  VIM::Buffer.current.count.times {|i| t += "#{VIM::Buffer.current[i + 1]}\n"}

  layout = <<-LAYOUT
  <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <style>
          * { margin: 0; padding: 0; }
        </style>
        #{set_stylesheets(default_styles)}
        #{set_stylesheets(user_styles)}
        <title>:: #{File.basename(name)} ::</title>
      </head>
      <body id="theme" class="#{css_namespace}">
        <div class="header">
          <h2>#{File.basename(name)}</h2>
          <select id='selects' onchange="selectTheme(event);">
            <optgroup label="Default Themes">
              #{set_options(default_styles, css_namespace)}
            </optgroup>
            <optgroup label="User Themes">
              #{set_options(user_styles, css_namespace)}
            </optgroup>
          </select>
        </div>
        <div class="wikistyle">
          #{BlueCloth.new(t).to_html}
        </div>
        <script language='javascript' type='text/javascript'>

          var themeID = document.getElementById('theme'),
              selects = document.getElementById('selects'),
              theme = themeID.className;

          function setTheme(new_theme, auto_select) {
            theme = new_theme;

            if (auto_select) {
              document.getElementById(theme).selected = 'selected';
            }

            themeID.className = theme;
            window.location.href = window.location.pathname + "#" + theme;
          }

          function selectTheme(e) {
            setTheme(e.target.value, false);
          }

          (function () {
            var hash = window.location.hash;
            if (hash) {
              theme = hash.substring(1, hash.length);
            }
            setTheme(theme, true);
          }());

        </script>
      </body>
    </html>
    LAYOUT

  File.open(tmp_file, 'w') do |f|
    f.write(layout)
  end

  if !tmp_exists || always_open == 1
    system("open #{tmp_file}")
  end

EOF
endfunction
:command! MDP :call MarkdownPreview()
:command! CMDP :call ClearMarkdownPreview()

