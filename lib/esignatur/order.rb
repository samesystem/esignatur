# frozen_string_literal: true

require 'esignatur/api_resource'
require 'esignatur/pades'
require 'esignatur/status'
require 'active_support/core_ext/string/inflections'

module Esignatur
  # esignatur order representation
  # More info: https://api.esignatur.dk/Documentation/Order
  class Order
    include ApiResource

    attr_reader :attributes

    def initialize(attributes: {}, api:)
      @attributes = attributes
      @api = api
    end

    def create(attributes)
      response = api_post('Order/Create', attributes)
      if errors.empty?
        body = response.json_body
        @attributes = attributes.merge(id: body.fetch('OrderId')).merge(body)
      end
      self
    end

    def id
      attributes[:id]
    end

    def status
      @status ||= Esignatur::Status.new(order: self, api: api).tap(&:fetch)
    end

    def cancel
      api_get("Order/Cancel/#{id}").success?
    end

    def pades
      @pades ||= Esignatur::Pades.new(order: self, api: api)
    end

    private

    attr_reader :api
  end
end
