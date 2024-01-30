# frozen_string_literal: true

require 'esignatur/api_resource'

module Esignatur
  # esignatur user representation
  # More info: https://api.esignatur.dk/Documentation/User
  class User
    include ApiResource

    DEFAULT_BASE_URL = 'https://api.esignatur.dk'

    def initialize(api_key:, base_url: DEFAULT_BASE_URL, creator_id:)
      @api = Esignatur::Api.new(
        api_key: api_key,
        base_url: base_url,
        creator_id: creator_id
      )

      @attributes = {}
    end

    def find_by(user_id:)
      response = api_get("user/get/#{user_id}")
      @attributes = response.json_body if errors.empty?
      self
    end

    private

    attr_reader :api, :attributes
  end
end
