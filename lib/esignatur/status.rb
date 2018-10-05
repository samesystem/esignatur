# frozen_string_literal: true

require 'esignatur/api_resource'

module Esignatur
  # esignatur status representation
  # More info: https://api.esignatur.dk/Documentation/Status
  class Status
    include ApiResource

    attr_reader :attributes, :order, :api

    def initialize(order:, attributes: {}, api:)
      @attributes = attributes
      @order = order
      @api = api
    end

    def fetch
      @attributes = api_get("status/get/#{order.id}").json_body
      self
    end
  end
end
