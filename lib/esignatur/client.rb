# frozen_string_literal: true

module Esignatur
  class Client
    DEFAULT_BASE_URL = 'https://api.esignatur.dk'.freeze

    def initialize(api_key:, base_url: DEFAULT_BASE_URL)
      @api = Esignatur::Api.new(api_key: api_key, base_url: base_url)
    end

    def orders
      Orders.new(api: api)
    end

    private

    attr_reader :api
  end
end
