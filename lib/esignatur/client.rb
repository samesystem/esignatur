# frozen_string_literal: true
module Esignatur
  # main API class
  class Client
    DEFAULT_BASE_URL = 'https://api.esignatur.dk'

    def initialize(api_key:, creator_id:, base_url: DEFAULT_BASE_URL)
      @api = Esignatur::Api.new(
        api_key: api_key,
        base_url: base_url,
        creator_id: creator_id
      )
    end

    def orders
      Orders.new(api: api)
    end

    private

    attr_reader :api
  end
end
