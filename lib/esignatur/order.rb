# frozen_string_literal: true

require 'esignatur/api_resource'
require 'esignatur/pades'
require 'esignatur/source_document'
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

    def cancel(attributes)
      camelized_attributes = attributes.transform_keys(&:to_s).transform_keys(&:camelize)
      creator_id = camelized_attributes.delete('CreatorId').to_s

      data = { 'OrderId' => id }.merge(camelized_attributes.compact)
      headers = { 'X-eSignatur-CreatorId': creator_id }

      api_post('Cancel/CancelOrder', data, headers: headers).success?
    end

    def pades_list
      @pades_list ||= status.attributes['Documents'].map do |document|
        Esignatur::Pades.new(order: self, attributes: document, api: api)
      end
    end

    def source_document
      @source_document ||= Esignatur::SourceDocument.new(order: self, api: api)
    end

    private

    attr_reader :api
  end
end
