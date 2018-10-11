# frozen_string_literal: true

require 'esignatur/api_resource'

module Esignatur
  # esignature PAdES document representation.
  # More info: https://api.esignatur.dk/Documentation/Pades
  class Pades
    include ApiResource

    attr_reader :attributes, :order

    def initialize(order:, api:)
      @attributes = {}
      @order = order
      @api = api
    end

    def document_data
      fetch if attributes.empty?
      Base64.decode64(attributes.fetch('DocumentData'))
    end

    def fetch
      @attributes = api_post('Pades/Download', 'Id' => order.id, 'DocumentIndex' => 0).json_body
    end

    private

    attr_reader :api
  end
end
