# frozen_string_literal: true

module Esignatur
  # add methods that are shared for all api resources
  module ApiResource
    def errors
      @errors || []
    end

    def last_response
      @last_response
    end

    protected

    def api_post(relative_url, data)
      make_api_request(:post, relative_url, data: data)
    end

    def api_get(relative_url, **options)
      make_api_request(:get, relative_url, **options)
    end

    private

    def make_api_request(http_method, relative_url, **options)
      @last_response = api.public_send(http_method, relative_url, **options).tap do |response|
        @errors = []
        @errors << response.headers['x-esignatur-error']
        @errors << "Request failed with HTTP status: #{response.status_code}" if response.failed?
        @errors = @errors.reject(&:nil?)
      end
    end
  end
end
