# frozen_string_literal: true

require 'spec_helper'

module Esignatur
  RSpec.describe Client do
    subject(:client) { described_class.new(api_key: 123) }

    describe '#orders' do
      subject(:orders) { client.orders }

      it { is_expected.to be_a(Esignatur::Orders) }
    end

    describe '#user' do
      let!(:status_request) do
        stub_request(:get, 'https://api.esignatur.dk/user/get/random')
          .and_return(body: File.read('spec/fixtures/user_response.json'))
      end

      subject(:user) { client.user('random', 'random') }

      it { is_expected.to be_a(Esignatur::User) }
    end
  end
end
