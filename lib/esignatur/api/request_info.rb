# frozen_string_literal: true

module Esignatur
  class Api
    # api response wrapper
    class RequestInfo
      attr_reader :url, :headers, :http_method

      def initialize(http_method, url, headers)
        @url = url
        @headers = headers
        @http_method = http_method
      end
    end
  end
end
