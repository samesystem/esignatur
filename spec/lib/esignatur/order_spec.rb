# frozen_string_literal: true

require 'spec_helper'

module Esignatur
  RSpec.describe Order do
    subject(:order) { described_class.new(order_id, api: api, response_body: raw_data) }

    let(:api) { Api.new(api_key: 123)}
    let(:order_id) { 1 }
    let(:raw_data) { nil }

    describe '.create' do
      subject(:create) { Order.create(attributes_for_create, api: api) }

      let(:attributes_for_create) do
        {
          CreatorId: 1,
          CommonNote: 'Test order.',
          ReminderDate: '2000-01-01',
          ReminderInterval: 2,
          EndDate: '2000-01-02',
          SenderEmail: 'john@example.com',
          Documents: [{ title: 'Doc', Filename: 'contract.pdf', DocumentFormat: 'Pdf', DocumentData: 'AAECAw==' }],
          steps: [
            { Signers: [{ name: 'John', email: 'john@example.com', identification: '23434234234234' }] },
            { Signers: [{ name: 'Jack', email: 'jack@example.com', identification: '23434234234235' }] }
          ]
        }
      end

      let!(:create_order_request) do
        stub_request(:post, "https://api.esignatur.dk/Order/Create")
          .to_return(body: File.read('spec/fixtures/order_create_response.json'))
      end

      it 'makes create request to api' do
        create
        expect(create_order_request).to have_been_made.once
      end

      it 'returns Order instance' do
        expect(create).to be_an(Order)
      end

      it 'returns order with id set' do
        expect(create.id).to eq 'eeeeeeee-3333-4444-aaaa-777777777777'
      end
    end

    describe '#status' do
      subject(:status) { order.status }

      let!(:status_request) do
        stub_request(:get, "https://api.esignatur.dk/status/get/1")
      end

      it 'makes status request to api' do
        status
        expect(status_request).to have_been_made.once
      end
    end

    describe '#cancel' do
      subject(:cancel) { order.cancel }

      let!(:cancel_order_request) do
        stub_request(:get, "https://api.esignatur.dk/Order/Cancel/1")
          .and_return(
            body: File.read('spec/fixtures/pades_download_response.json'),
            status: response_status_for_cancel
          )
      end

      let(:response_status_for_cancel) { 200 }

      it 'makes cancel request to api' do
        cancel
        expect(cancel_order_request).to have_been_made.once
      end

      context 'when request is successfull' do
        it { is_expected.to be true }
      end

      context 'when request is not successfull' do
        let(:response_status_for_cancel) { 500 }

        it { is_expected.to be false }
      end
    end

    describe '#pades' do
      subject(:pades) { order.pades }

      it { is_expected.to be_an(Pades) }
    end
  end
end