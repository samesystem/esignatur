# frozen_string_literal: true

module Esignatur
  # esignatur order info collection representation.
  # more info: https://api.esignatur.dk/Documentation/OrderInfo
  class Orders
    include Enumerable

    def initialize(scope: {}, api:)
      @scope = scope
      @api = api
    end

    def create(attributes)
      Order.create(attributes, api: api)
    end

    def where(new_scope)
      self.class.new(scope: scope.merge(new_scope), api: api)
    end

    def all
      @all ||= begin
        response = api.get("OrderInfo/OrdersForAdministrator/#{creator_id}", headers: headers_for_all_query)
        response.json_body.fetch('SignOrders').map do |raw_order|
          Order.new(raw_order.fetch('SignOrderId'), response_body: raw_order, api: api)
        end
      end
    end

    def each(&block)
      all.each(&block)
    end

    def find(id)
      Order.new(id, api: api)
    end

    private

    attr_reader :api, :scope

    def headers_for_all_query
      modified_since = scope[:modified_since]&.iso8601
      modified_since ? { 'If-Modified-Since' => modified_since } : {}
    end

    def creator_id
      scope.fetch(:creator_id) do
        raise(
          Esignatur::Error,
          'You need to specify creator_id in order to fech orders. ' \
          'You can do this with `esignatur.orders.where(creator_id: 123)`'
        )
      end
    end
  end
end
