## Hacker news parser

Simple parser for Hacker News newest posts. 

``` ruby
parser Parsers::HackerNews::NewLinks.new
parser.parse_links(nil, 5) # it mean: we parse only 5 pages without needed id
```
