# markdown-preview.vim

Markdown Preview allows you to compile and preview markdown as generated HTML
files. It has the ability to select and use customized stylesheets for 
previewing your own awesomeness. Previewing occurs within the default browser.

For more information on the plugin: `:help markdown-preview` within Vim or take a look at the [help files](http://github.com/mkitt/markdown-preview.vim/blob/master/doc/markdown-preview.txt) on github.


## Install

Download, fork, clone, or use it as a submodule within your .vim directory.


## Dependencies

Markdown Preview requires the following:

- Vim version 7.0 or above
- Ruby support for Vim
- BlueCloth for converting markdown to html `gem install bluecloth`

While not a requirement, default directories are tailored to work within a
bundle directory as specified by the pathogen plugin.

Has only been tested to work with MacVim and Vim from Terminal at this point.


## Todo

- Add the ability to save HTML output instead of the tmp directory?
- Generate PDFs instead of using the browsers save as feature?
- Navigate to position in browser from position of cursor within file
- Remove the dependency for BlueCloth


## Credits

Inspired by:

- [Mathias Biilmann plugin](http://mathias-biilmann.net/2009/1/markdown-preview-in-vim)
- [Rob Gleeson's plugin](http://github.com/robgleeson/vim-markdown-preview)

## Contributing

Contributions are welcome, simply fork do your magic and send me a pull request.


## MIT License

Copyright (c) 2010 by Matthew Kitt

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the 'Software'), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE

