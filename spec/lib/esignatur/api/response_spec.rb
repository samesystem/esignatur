require 'spec_helper'

module Esignatur
  class Api
    RSpec.describe Response do
      subject(:api_response) { described_class.new(original_response) }

      let(:original_response) { instance_double(Faraday::Response, headers: {}) }

      describe '#method_missing' do
        it 'delegates unknown methods to original response' do
          api_response.headers
          expect(original_response).to have_received(:headers).once
        end
      end

      describe '#respond_to?' do
        it 'checks for method persence on original response' do
          expect(api_response).to be_respond_to(:headers)
        end
      end
    end
  end
end
