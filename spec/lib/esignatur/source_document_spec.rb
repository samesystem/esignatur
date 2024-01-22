# frozen_string_literal: true

require 'spec_helper'

module Esignatur
  RSpec.describe SourceDocument do
    subject(:source_document) { described_class.new(order: order, api: api) }

    let(:order) { Order.new(attributes: { id: 1 }, api: api) }
    let(:api) { Api.new(api_key: 123, creator_id: 1) }

    let!(:download_source_document_request) do
      stub_request(:post, 'https://api.esignatur.dk/SourceDocument/Download')
        .with(
          body: { Id: 1, DocumentIndex: 0 }.to_json,
          headers: { 'X-Esignatur-Id' => '123' }
        ).and_return(
          body: File.read('spec/fixtures/source_document_response.json'),
          status: response_status_code
        )
    end

    let(:response_status_code) { 200 }

    describe '#document_data' do
      subject(:document_data) { source_document.document_data }

      it 'makes download source_document request to api' do
        document_data
        expect(download_source_document_request).to have_been_made
      end

      it 'encodes content' do
        expect(document_data).not_to include('==')
      end
    end

    describe '#fetch' do
      subject(:fetch) { source_document.fetch }

      context 'when request is not successfull' do
        let(:response_status_code) { 500 }

        it 'does not update attributes' do
          expect { fetch }.not_to change(source_document, :attributes)
        end
      end

      context 'when request is successfull' do
        it 'updates attributes' do
          expect { fetch }.to change(source_document, :attributes)
        end
      end
    end
  end
end
