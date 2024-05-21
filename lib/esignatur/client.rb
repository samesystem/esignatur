# frozen_string_literal: true
module Esignatur
  # main API class
  class Client
    DEFAULT_BASE_URL = 'https://api.esignatur.dk'

    def initialize(**options)
      @api = Esignatur::Api.new(**options)
    end

    def orders
      Orders.new(api: api)
    end

    private

    attr_reader :api
  end
end
