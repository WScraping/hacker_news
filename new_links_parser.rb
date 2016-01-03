require_relative 'base_parser'

module Parsers
  module HackerNews
    class NewLinks < BaseParser

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
