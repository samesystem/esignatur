# frozen_string_literal: true

require 'esignatur/api_resource'

module Esignatur
  # esignature PAdES document representation.
  # More info: https://api.esignatur.dk/Documentation/Pades
  class Pade
    include ApiResource

    attr_reader :attributes, :order, :document

    def initialize(order:, document:, api:)
      @attributes = {}
      @order = order
      @document = document
      @api = api
    end

    def document_data
      fetch if attributes.empty?
      Base64.decode64(attributes.fetch('DocumentData'))
    end

    def fetch
      response = api_post('Pades/Download', 'Id' => order.id, 'AgreementId' => document[:AgreementId])
      @attributes = response.json_body if errors.empty?
      self
    end

    private

    attr_reader :api
  end
end
