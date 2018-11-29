# frozen_string_literal: true

require 'spec_helper'

module Esignatur
  RSpec.describe Pades do
    subject(:pades) { described_class.new(order: order, api: api) }

    let(:order) { Order.new(attributes: { id: 1 }, api: api) }
    let(:api) { Api.new(api_key: 123) }

    describe '#document_data' do
      subject(:document_data) { pades.document_data }

      let!(:download_pades_request) do
        stub_request(:post, 'https://api.esignatur.dk/Pades/Download')
          .with(
            body: { Id: 1, DocumentIndex: 0 }.to_json,
            headers: { 'X-Esignatur-Id' => '123' }
          ).and_return(body: File.read('spec/fixtures/pades_download_response.json'))
      end

      it 'makes download pades request to api' do
        document_data
        expect(download_pades_request).to have_been_made
      end

      it 'encodes content' do
        expect(document_data).not_to include('==') # "==" is an indicator for base64 encoding
      end
    end
  end
end
