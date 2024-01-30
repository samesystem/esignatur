# frozen_string_literal: true

require 'spec_helper'

module Esignatur
  RSpec.describe Status do
    subject(:status) { described_class.new(order: order, api: api) }

    let(:api) { Esignatur::Api.new(api_key: '123', creator_id: 1) }
    let(:order) { Esignatur::Order.new(attributes: { id: 1 }, api: api) }

    describe '#fetch' do
      subject(:fetch) { status.fetch }

      let!(:status_request) do
        stub_request(:get, 'https://api.esignatur.dk/status/get/1')
          .and_return(
            body: File.read('spec/fixtures/pades_download_response.json'),
            status: response_status_code
          )
      end

      let(:response_status_code) { 200 }

      it 'makes esignatur status request' do
        fetch
        expect(status_request).to have_been_made
      end

      context 'when request is not successfull' do
        let(:response_status_code) { 500 }

        it 'does not update attributes' do
          expect { fetch }.not_to change(status, :attributes)
        end
      end

      context 'when request is successfull' do
        it 'updates attributes' do
          expect { fetch }.to change(status, :attributes)
        end
      end
    end
  end
end
