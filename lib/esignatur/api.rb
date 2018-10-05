# frozen_string_literal: true

require 'esignatur/api/response'
require 'esignatur/api/request_info'

module Esignatur
  # all raw http requests are made using Api instance
  class Api
    require 'faraday'

    DEFAULT_BASE_URL = 'https://api.esignatur.dk'

    def initialize(api_key:, base_url: DEFAULT_BASE_URL)
      @api_key = api_key.to_s
      @base_url = base_url
    end

    def post(relative_url, data:, headers: {})
      make_request(:post, relative_url, data: data, extra_headers: headers)
    end

    def get(relative_url, headers: {})
      make_request(:get, relative_url, extra_headers: headers)
    end

    private

    attr_reader :base_url, :api_key

    def make_request(http_method, relative_url, extra_headers: {}, data: nil)
      url = URI.join(base_url, relative_url).to_s

      headers = default_headers.merge(extra_headers)
      raw_response = Faraday.public_send(http_method, url, data&.to_json, headers)
      request = RequestInfo.new(http_method, url, headers)
      Esignatur::Api::Response.new(raw_response, request: request)
    end

    def default_headers
      {
        'X-eSignatur-Id' => api_key,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
    end
  end
end
