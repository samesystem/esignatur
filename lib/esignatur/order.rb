# frozen_string_literal: true

require 'esignatur/pades'
require 'active_support/core_ext/string/inflections'

module Esignatur
  # esignatur order representation
  # More info: https://api.esignatur.dk/Documentation/Order
  class Order
    attr_reader :id, :response_body

    def self.create(attributes, api:)
      response = api.post('Order/Create', data: attributes)
      body = response.json_body
      new(body.fetch('OrderId'), response_body: response.body, api: api)
    end

    def initialize(id, response_body: nil, api:)
      @id = id
      @response_body = response_body
      @api = api
    end

    def status
      api.get("status/get/#{id}")
    end

    def cancel
      api.get("Order/Cancel/#{id}").success?
    end

    def pades
      Pades.new(order: self, api: api)
    end

    private

    attr_reader :api
  end
end
