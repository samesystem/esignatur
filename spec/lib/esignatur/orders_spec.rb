# frozen_string_literal: true

require 'spec_helper'
module Esignatur
  RSpec.describe Orders do
    shared_context 'with stubbed orders info request' do
      let!(:orders_info_request) do
        stub_request(:get, "https://api.esignatur.dk/OrderInfo/OrdersForAdministrator/#{creator_id}")
          .with(headers: { 'X-Esignatur-Id' => '123' })
          .to_return(body: File.read('spec/fixtures/sign_orders_response.json'))
      end
    end

    subject(:orders) { initial_orders }

    let(:initial_orders) { described_class.new(api: api).where(creator_id: creator_id) }
    let(:api) { Esignatur::Api.new(api_key: '123') }
    let(:creator_id) { 1 }

    describe '#each' do
      include_context 'with stubbed orders info request'

      it 'iterates through all orders' do
        creator_orders = orders.where(creator_id: creator_id)
        expect(creator_orders.each.map(&:itself)).to eq creator_orders.all
      end
    end

    describe '#all' do
      include_context 'with stubbed orders info request'

      subject(:all_orders) { orders.all }

      it 'makes orders info request' do
        all_orders
        expect(orders_info_request).to have_been_made
      end

      it 'returns orders array' do
        expect(all_orders).to all(be_an(Esignatur::Order))
      end
    end

    describe '#find' do
      subject(:order) { orders.find(1) }

      it { is_expected.to be_a(Esignatur::Order) }

      it 'returns order with given id' do
        expect(order.id).to eq 1
      end
    end

    describe '#where' do
      context 'when creator id is not given' do
        subject(:orders) { described_class.new(api: api).where({}) }

        it 'raises error durring fetch' do
          expect { orders.all }.to raise_error(Esignatur::Error)
        end
      end

      context 'when modified_since is given' do
        subject(:orders) { initial_orders.where(modified_since: Date.new(2010, 1, 1)) }

        include_context 'with stubbed orders info request'

        it 'makes request with "modified since" header' do
          request_with_header = orders_info_request.with(headers: { 'If-Modified-Since' => '2010-01-01' })
          orders.all
          expect(request_with_header).to have_been_made
        end
      end

      context 'when modified_since is not given' do
        subject(:orders) { initial_orders }

        include_context 'with stubbed orders info request'

        it 'makes orders info request', :aggregate_failures do
          orders.all
          expect(orders_info_request).to have_been_made
        end

        it 'does not include "modified since" header' do
          orders.all
          request_with_header = orders_info_request.with(headers: { 'If-Modified-Since' => '2010-01-01' })
          expect(request_with_header).not_to have_been_made
        end
      end
    end

    describe '#create' do
      let!(:create_order_request) do
        stub_request(:post, 'https://api.esignatur.dk/Order/Create')
          .and_return(body: File.read('spec/fixtures/order_create_response.json'))
      end

      it 'makes create request' do
        orders.create({})
        expect(create_order_request).to have_been_made
      end
    end
  end
end
