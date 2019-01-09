# frozen_string_literal: true

require 'esignatur/api_resource'

module Esignatur
  # esignature SourceDocument document representation.
  # More info: https://api.esignatur.dk/Documentation/SourceDocument
  class SourceDocument
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
      response = api_post('SourceDocument/Download',
                          'Id' => order.id, 'DocumentIndex' => 0)
      @attributes = response.json_body if errors.empty?
      self
    end

    private

    attr_reader :api
  end
end
