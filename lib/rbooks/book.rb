module Rbooks
  require "uri"
  require "net/http"

  class Book
    DEFAULT_OPT = {format: "json", formatVersion: "1"}
    REQUIRE_URL_ENCODE = [:title, :author, :publisher, :isbn, :booksGenreId]

    class << self
      def search(opt)
        params = DEFAULT_OPT.merge(opt)
        params = self.concat_each_item_by_space params

        uri = URI(Rbook::ENDPOINT_URL)
        uri.query = URI.encode_www_form(params)

        response = Net::HTTP.get_response(uri)
      end

      def concat_each_item_by_space(params)
        REQUIRE_URL_ENCODE.each do |key|
          params[key] = params[key].join(' ') if params.key? key
        end

        return params
      end
    end

    def initialize(response)
      @response = response
    end
  end

  class << self
    def url_encode(str)
      URI.encode_www_form_component str
    end
  end
end