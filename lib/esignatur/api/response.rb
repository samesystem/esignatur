# frozen_string_literal: true

module Esignatur
  class Api
    # api response wrapper
    class Response
      attr_reader :original_response

      def initialize(original_response)
        @original_response = original_response
      end

      def body
        original_response.body
      end

      def json_body
        JSON.parse(body)
      end

      def method_missing(method_name, *args)
        original_respond_to?(method_name, *args) ? original_response.public_send(method_name, *args) : super
      end

      def respond_to_missing?(method_name, *args)
        original_respond_to?(method_name, *args) || super
      end

      private

      def original_respond_to?(method_name, *args)
        original_response.respond_to?(method_name, *args)
      end
    end
  end
end
