require_relative 'base_parser'

module Parsers
  module HackerNews
    class Jobs < BaseParser

      # Runs a parsing process
      # Params:
      # +limit_url+:: sring url value for end url address(may be nil)
      # +pages+:: number of pages for parsing (default: 1)
      def parse_links(limit_url = nil, pages = 1)
        @page = @agent.get "#{BASE_URL}/jobs"
        view_more(pages) do
          links = @page.search("//td[contains(@class,'title') and "\
                              "not(contains(.,'More'))]/a")

          links.each do |link|
            current_data = scrape_link_data(link)
            return @data if limit_url && current_data[:link] == limit_url

            break if @data.include?(current_data)
            @data << current_data
          end
        end
      end

      # Scrape data from link
      def scrape_link_data(link)
        { title: link.text, link: link[:href] }
      end
    end
  end
end
