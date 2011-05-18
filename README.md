## NOTE THE REDCARPET IMPLEMENTATION HAS BEEN ROLLED BACK TO DISCOUNT. RUBY GEMS IS BASICALLY A JUNK SHOW AT THE MOMENT. MORE COMING SOON

# markdown-preview.vim

Markdown Preview allows you to compile and preview markdown as generated HTML files. It has the ability to select and use customized stylesheets for  previewing your own awesomeness. Previewing occurs within the default browser.

For more information on the plugin: `:help markdown-preview` within Vim or take a look at the [help files](http://github.com/mkitt/markdown-preview.vim/blob/master/doc/markdown-preview.txt) on github.


## Install

Download, fork, clone, or use it as a submodule within your .vim directory.


## Dependencies

Markdown Preview requires the following:

- Vim version 7.0 or above with Ruby support
- [redcarpet][redcarpet] for converting markdown to html and it's available in your path

To install [redcarpet][redcarpet] run the following:

    gem install redcarpet

[redcarpet][redcarpet] is the same gem used to generate [github flavored markdown](http://github.github.com/github-flavored-markdown/). It runs with the following extensions turned on.

```ruby
:hard_wrap
:gh_blockcode
:autolink
:tables
:strikethrough
:fenced_code
:lax_htmlblock
:no_intraemphasis
:space_header
```

These extensions are best documented in the [redcarpet tests](https://github.com/tanoku/redcarpet/blob/master/test/redcarpet_test.rb). Some of these extensions may or may not be turned on for github.

While not a requirement, default directories are tailored to work within a bundle directory as specified by the pathogen plugin.

Has only been tested to work with MacVim and Vim from Terminal at this point.


## Todo

- Multiple User Style Directories
- Syntax highlighting with `:fenced_code`


## Credits

- [Tanoku's](https://github.com/tanoku) excellent gem for [redcarpet][redcarpet] and [upskirt](https://github.com/tanoku/upskirt/)

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

[redcarpet]: https://github.com/tanoku/redcarpet
