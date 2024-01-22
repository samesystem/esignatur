# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Esignatur::ApiResource do
  class DummyApiResource
    include Esignatur::ApiResource

    def api
      @api ||= Esignatur::Api.new(api_key: 123, creator_id: 1)
    end

    def do_request
      api_get('get/path', headers: { 'foo': 'bar' })
    end
  end

  subject(:api_resource) { DummyApiResource.new }

  let(:response_headers) { {} }
  let(:response_status) { 200 }
  let(:response) { { status: response_status, body: '{}', headers: response_headers } }

  before do
    stub_request(:get, 'https://api.esignatur.dk/get/path')
      .with(
        headers: {
          'Accept' => 'application/json',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type' => 'application/json',
          'Foo' => 'bar',
          'X-Esignatur-Id' => '123'
        }
      )
      .to_return(response)
  end

  describe '#errors' do
    subject(:errors) { api_resource.tap(&:do_request).errors }

    context 'when response contains "x-esignatur-error"' do
      let(:response_headers) { { 'x-esignatur-error': 'boom!' } }

      it 'includes header info in errors' do
        expect(errors).to eq(['boom!'])
      end
    end

    context 'when response is not successfull' do
      let(:response_status) { 500 }

      it 'includes bad response error' do
        expect(errors).to eq(['Request failed with HTTP status: 500'])
      end
    end

    context 'when response is successfull' do
      it { is_expected.to be_empty }
    end
  end

  describe '#last_response' do
    context 'when no request have been made' do
      it 'is blank' do
        expect(api_resource.last_response).to be_nil
      end
    end

    context 'when request have been made' do
      it 'sets last response' do
        expect { api_resource.do_request }.to change(api_resource, :last_response).from(nil)
      end
    end

    context 'when request have been made multiple times' do
      it 'sets last called response' do
        response_before = api_resource.tap(&:do_request).last_response
        expect { api_resource.do_request }.to change(api_resource, :last_response).from(response_before)
      end
    end
  end
end
