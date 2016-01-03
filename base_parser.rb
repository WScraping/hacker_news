require 'rubygems'
require 'mechanize'

module Parsers
  module HackerNews
    class BaseParser
      BASE_URL = 'https://news.ycombinator.com'
      attr_accessor :agent, :data

      def initialize
        @agent = Mechanize.new do |agent|
          agent.user_agent_alias = 'Mac Safari'
        end
        @data = []
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
    end
  end
end
