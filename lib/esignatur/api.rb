# frozen_string_literal: true

require 'esignatur/api/response'
require 'esignatur/api/request_info'

module Esignatur
  # all raw http requests are made using Api instance
  class Api
    require 'faraday'

    DEFAULT_BASE_URL = 'https://api.esignatur.dk'

    attr_reader :creator_id

    def initialize(api_key:, creator_id:, base_url: DEFAULT_BASE_URL, timeout: nil)
      @api_key = api_key.to_s
      @base_url = base_url
      @creator_id = creator_id
      @default_timeout = timeout
    end

    def post(relative_url, data:, headers: {}, timeout: nil)
      make_request(:post, relative_url, data: data, extra_headers: headers)
    end

    def get(relative_url, headers: {}, timeout: nil)
      make_request(:get, relative_url, extra_headers: headers, timeout: timeout)
    end

    private

    attr_reader :base_url, :api_key, :default_timeout

    def make_request(http_method, relative_url, extra_headers: {}, data: nil, timeout: nil)
      url = URI.join(base_url, relative_url).to_s
      headers = default_headers.merge(extra_headers)

      raw_response = connection(timeout: timeout).public_send(http_method, url, data&.to_json, headers)
      request = RequestInfo.new(http_method, url, headers)
      Esignatur::Api::Response.new(raw_response, request: request)
    end

    def connection(timeout: nil)
      request_timeout = timeout || default_timeout

      Faraday.new do |conn|
        conn.options.timeout = request_timeout if request_timeout
      end
    end

    def default_headers
      {
        'X-eSignatur-Id' => api_key,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
        'X-eSignatur-CreatorId' => creator_id&.to_s
      }.compact
    end
  end
end
