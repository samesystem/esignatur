# frozen_string_literal: true

require 'spec_helper'

module Esignatur
  RSpec.describe Client do
    subject(:client) { described_class.new(api_key: 123, creator_id: 1) }

    describe '#orders' do
      subject(:orders) { client.orders }

      it { is_expected.to be_a(Esignatur::Orders) }
    end
  end
end
