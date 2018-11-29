require 'spec_helper'

module Esignatur
  class Api
    RSpec.describe Response do
      subject(:api_response) { described_class.new(original_response, request: nil) }

      let(:original_response) { instance_double(Faraday::Response, status: 200, body: body) }
      let(:body) { '{ "hello": "world" }' }

      describe 'json_body' do
        subject(:json_body) { api_response.json_body }

        context 'when response body is formatted as json' do
          it 'parses response' do
            expect(json_body).to eq('hello' => 'world')
          end
        end

        context 'when response body is not formatted as json' do
          let(:body) { 'this is not JSON' }

          it 'raises parsing error' do
            expect { json_body }.to raise_error(Esignatur::Error)
          end
        end
      end

      describe '#method_missing' do
        it 'delegates unknown methods to original response' do
          api_response.status
          expect(original_response).to have_received(:status)
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
