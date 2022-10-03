# frozen_string_literal: true

require 'esignatur/api_resource'

module Esignatur
  # esignature PAdES document representation.
  # More info: https://api.esignatur.dk/Documentation/Pades
  class Pades
    include ApiResource

    attr_reader :attributes, :order

    def initialize(order:, attributes: {}, api:)
      @attributes = attributes
      @order = order
      @api = api
    end

    def document_data
      fetch unless attributes.key?('DocumentData')
      Base64.decode64(attributes.fetch('DocumentData'))
    end

    def title
      fetch unless attributes.key?('Title')
      attributes['Title']
    end

    def filename
      fetch unless attributes.key?('Filename')
      attributes['Filename']
    end

    def document_id
      fetch unless attributes.key?('DocumentId')
      attributes['DocumentId']
    end

    def fetch
      response = api_post(
        'Pades/Download',
        {
          'Id' => order.id, 'AgreementId' => attributes['AgreementId']
        }
      )
      @attributes = response.json_body if errors.empty?
      self
    end

    private

    attr_reader :api
  end
end
