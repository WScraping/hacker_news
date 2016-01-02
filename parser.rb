require 'rubygems'
require 'mechanize'

module Parsers
  module HackerNews
    class NewLinks
      BASE_URL = 'https://news.ycombinator.com'

      attr_accessor :agent, :data

      # Initialize Mechanize instance and variable for parsed data
      def initialize
        @agent = Mechanize.new do |agent|
          agent.user_agent_alias = 'Mac Safari'
        end
        @data = []
      end

      # Runs a parsing process
      # Params:
      # +limit_id+:: id +Integer+ value for end id value(may be nil)
      # +pages+:: number of pages for parsing (default: 1)
      def parse_links(limit_id = nil, pages = 1)
        @page = @agent.get "#{BASE_URL}/newest"
        view_more(pages) do
          rows = @page.search("//tr[contains(@class,'athing') or "\
                              "contains(.,'point') and "\
                              "not(contains(.,'More'))]")

          rows.each_slice(2) do |row_pair|
            current_data = scrape_header_row(row_pair.first)
            current_data.merge!(scrape_detail_row(row_pair.last))
            return @data if limit_id && current_data[:id] < limit_id

            break if @data.include?(current_data)
            @data << current_data
          end
        end
      end

      # Method for pagination, just clicking on More link
      def view_more(pages = 1)
        page_num = 0
        loop do
          yield

          next_link = @page.link_with(text: 'More')
          break if page_num > pages || !next_link

          page_num += 1
          @page = next_link.click
        end
      end

      # Scrape data from header row
      def scrape_header_row(row)
        header = row.text.match(/\d+\.\s+(?<title>.+)\s\(?(?<site>[\w.]+)?\)?/)

        { title: header[:title], site: header[:site] }
      end

      # Scrape data from detail row (second row)
      def scrape_detail_row(row)
        discuss_tag = row.at(".//a[contains(.,'discuss') or "\
                              "contains(.,'comments') or "\
                              "contains(.,'comment')]")
        duscuss_link = discuss_tag[:href]

        {
          id: discuss_tag[:href][/\d+$/].to_i,
          point: row.at(".//span[@class='score']").text,
          user_name: row.at(".//a[contains(@href,'user?id=')]").text,
          link: duscuss_link,
          full_url: "#{BASE_URL}/#{duscuss_link}"
        }
      end
    end
  end
end
