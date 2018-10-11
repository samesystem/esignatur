# frozen_string_literal: true

require 'esignatur/error'

module Esignatur
  class Api
    # api response wrapper
    class Response
      attr_reader :request

      def initialize(original_response, request:)
        @original_response = original_response
        @request = request
      end

      def body
        original_response.body
      end

      def status_code
        original_response.status
      end

      def headers
        original_response.headers
      end

      def success?
        original_response.success?
      end

      def failed?
        !success?
      end

      def json_body
        JSON.parse(body)
      rescue JSON::ParserError => error
        error.extend(Esignatur::ParsingError)
        raise error
      end

      def method_missing(method_name, *args)
        original_respond_to?(method_name, *args) ? original_response.public_send(method_name, *args) : super
      end

      def respond_to_missing?(method_name, *args)
        original_respond_to?(method_name, *args) || super
      end

      private

      attr_reader :original_response

      def original_respond_to?(method_name, *args)
        original_response.respond_to?(method_name, *args)
      end
    end
  end
end
