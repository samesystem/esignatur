# frozen_string_literal: true

require 'spec_helper'

module Esignatur
  RSpec.describe Order do
    subject(:order) { described_class.new(attributes: { id: order_id }, api: api) }

    let(:api) { Api.new(api_key: 123) }
    let(:order_id) { 1 }

    describe '#create' do
      subject(:create) { order.create(attributes_for_create) }

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
        stub_request(:post, 'https://api.esignatur.dk/Order/Create')
          .to_return(body: File.read('spec/fixtures/order_create_response.json'))
      end

      it 'makes create request to api' do
        create
        expect(create_order_request).to have_been_made
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
        stub_request(:get, 'https://api.esignatur.dk/status/get/1')
          .and_return(body: File.read('spec/fixtures/pades_download_response.json'))
      end

      it 'makes status request to api' do
        status
        expect(status_request).to have_been_made
      end

      it 'returns instance of Status' do
        expect(status).to be_a(Esignatur::Status)
      end
    end

    describe '#cancel' do
      subject(:cancel) { order.cancel(reason: cancel_reason, silent: cancel_silently) }

      let(:cancel_reason) { nil }
      let(:cancel_silently) { nil }

      let!(:cancel_order_request) do
        stub_request(:post, 'https://api.esignatur.dk/Cancel/CancelOrder')
          .and_return(
            body: 'Order d874accf-d6f3-4352-870b-3ea24f0761d4 pending cancellation',
            status: response_status_for_cancel
          )
      end

      let(:response_status_for_cancel) { 200 }

      it 'makes cancel request to api' do

      end

      context 'when no optional params are given' do
        it 'makes cancel request with OrderId only' do
          input_body = { OrderId: order_id }.to_json
          request_with_order_id = cancel_order_request.with(body: input_body)
          cancel
          expect(request_with_order_id).to have_been_made
        end
      end

      context 'when reason is given' do
        let(:cancel_reason) { 'not needed anymore' }

        it 'includes reason in to request' do
          input_body = { OrderId: order_id, Reason: cancel_reason }.to_json
          request_with_reason_param = cancel_order_request.with(body: input_body)
          cancel
          expect(request_with_reason_param).to have_been_made
        end
      end

      context 'when :silent flag is given' do
        let(:cancel_silently) { true }

        it 'includes reason in to request' do
          input_body = { OrderId: order_id, Silent: true }.to_json
          request_with_silent_param = cancel_order_request.with(body: input_body)
          cancel
          expect(request_with_silent_param).to have_been_made
        end
      end

      context 'when request is successfull' do
        it { is_expected.to be true }
      end

      context 'when request is not successfull' do
        let(:response_status_for_cancel) { 500 }

        it { is_expected.to be false }
      end
    end

    describe '#pades_list' do
      subject(:pades_list) { order.pades_list }

      before do
        stub_request(:get, 'https://api.esignatur.dk/status/get/1')
          .and_return(body: File.read('spec/fixtures/status_response.json'))
      end

      it 'returns same pades_list instance every time' do
        expect(order.pades_list).to be order.pades_list
      end
    end
  end
end
