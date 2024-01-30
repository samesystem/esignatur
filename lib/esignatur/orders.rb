# frozen_string_literal: true

require 'esignatur/api_resource'

module Esignatur
  # esignatur order info collection representation.
  # more info: https://api.esignatur.dk/Documentation/OrderInfo
  class Orders
    include ::Esignatur::ApiResource
    include Enumerable

    def initialize(scope: {}, api:)
      @scope = scope
      @api = api
    end

    def create(attributes = {}, **keyword_attributes)
      build.create(attributes, **keyword_attributes)
    end

    def build
      Esignatur::Order.new(api: api)
    end

    def where(new_scope)
      self.class.new(scope: scope.merge(new_scope), api: api)
    end

    def all
      @all ||= begin
        response = api_get("OrderInfo/OrdersForAdministrator/#{api.creator_id}", headers: headers_for_all_query)
        response.json_body.fetch('SignOrders').map do |raw_order|
          order_attributes = raw_order.merge(id: raw_order.fetch('SignOrderId'))
          Esignatur::Order.new(attributes: order_attributes, api: api)
        end
      end
    end

    def each(&block)
      all.each(&block)
    end

    def find(id)
      Esignatur::Order.new(attributes: { id: id }, api: api)
    end

    private

    attr_reader :api, :scope

    def headers_for_all_query
      modified_since = scope[:modified_since]&.iso8601
      modified_since ? { 'If-Modified-Since' => modified_since } : {}
    end
  end
end
