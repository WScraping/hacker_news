# Hacker news parser
Article: [Scrape Hacker News newest posts](http://max-si-m.github.io/scraping-haker-news-posts/)

Simple parser for Hacker News newest posts. Just for fun, maybe it will be helpful for someone :smile:

## Usage

Very simple:

``` ruby
parser = Parsers::HackerNews::NewLinks.new
parser.parse_links(nil, 5) # it mean: we parse only 5 pages without needed id
parser.data #=> Array[..]

###############################################################
parser = Parsers::HackerNews::Jobs.new
parser.parse_links(nil, 5) #parse 5 pages
parser.data #=> Array[...]
```


## Contributing

1. Fork it ( https://github.com/WScraping/hacker_news )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
