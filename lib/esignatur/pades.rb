# frozen_string_literal: true

module Esignatur
  # esignature PAdES document representation.
  # More info: https://api.esignatur.dk/Documentation/Pades
  class Pades
    attr_reader :order

    def initialize(order:, api:)
      @order = order
      @api = api
    end

    def document_data
      Base64.decode64(response_body.fetch('DocumentData'))
    end

    def response_body
      @response_body ||= \
        api.post('Pades/Download', data: { 'Id' => order.id, 'DocumentIndex' => 0 }).json_body
    end

    private

    attr_reader :api
  end
end
