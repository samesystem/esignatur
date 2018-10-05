# frozen_string_literal: true

require 'spec_helper'

module Esignatur
  RSpec.describe Status do
    subject(:status) { described_class.new(order: order, api: api) }

    let(:api) { Esignatur::Api.new(api_key: '123') }
    let(:order) { Esignatur::Order.new(attributes: { id: 1 }, api: api) }

    describe '#fetch' do
      subject(:fetch) { status.fetch }

      let!(:status_request) do
        stub_request(:get, 'https://api.esignatur.dk/status/get/1')
          .and_return(body: File.read('spec/fixtures/pades_download_response.json'))
      end

      it 'makes esignatur status request' do
        fetch
        expect(status_request).to have_been_made.once
      end

      it 'updates attributes' do
        expect { fetch }.to change(status, :attributes)
      end
    end
  end
end
