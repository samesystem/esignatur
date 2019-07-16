# frozen_string_literal: true

require 'esignatur/api_resource'

module Esignatur
  # esignatur user representation
  # More info: https://api.esignatur.dk/Documentation/User
  class User
    include ApiResource

    attr_reader :attributes, :user_id, :creator_id, :api

    def initialize(user_id: user, creator_id: creator_id,  attributes: {}, api:)
      @attributes = attributes
      @user_id = user_id
      @api = api
      @creator_id = creator_id
    end

    def fetch
      headers = { 'X-eSignatur-CreatorId': creator_id }
      response = api_get("user/get/#{user_id}", headers: headers)
      @attributes = response.json_body if errors.empty?
      self
    end
  end
end
