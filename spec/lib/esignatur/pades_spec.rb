# frozen_string_literal: true

require 'spec_helper'

module Esignatur
  RSpec.describe Pades do
    subject(:pades) { described_class.new(order: order, attributes: attributes, api: api) }

    let(:order) { Order.new(attributes: { id: 1 }, api: api) }
    let(:agreement_id) { '044e04fcJnNU67676' }
    let(:attributes) { { 'AgreementId' => agreement_id } }
    let(:api) { Api.new(api_key: 123) }

    let!(:download_pades_request) do
      stub_request(:post, 'https://api.esignatur.dk/Pades/Download')
        .with(
          body: { Id: 1, AgreementId: agreement_id }.to_json,
          headers: { 'X-Esignatur-Id' => '123' }
        ).and_return(
          body: File.read('spec/fixtures/pades_download_response.json'),
          status: response_status_code
        )
    end

    let(:response_status_code) { 200 }

    describe '#document_data' do
      subject(:document_data) { pades.document_data }

      it 'makes download pades request to api' do
        document_data
        expect(download_pades_request).to have_been_made
      end

      it 'encodes content' do
        expect(document_data).not_to include('==') # "==" is an indicator for base64 encoding
      end
    end

    describe '#fetch' do
      subject(:fetch) { pades.fetch }

      context 'when request is not successfull' do
        let(:response_status_code) { 500 }

        it 'does not update attributes' do
          expect { fetch }.not_to change(pades, :attributes)
        end
      end

      context 'when request is successfull' do
        it 'updates attributes' do
          expect { fetch }.to change(pades, :attributes)
        end
      end
    end
  end
end
