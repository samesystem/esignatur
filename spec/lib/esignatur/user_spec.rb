# frozen_string_literal: true

require 'spec_helper'

module Esignatur
  RSpec.describe User do
    subject(:user) { described_class.new(api_key: 123) }

    let(:user_id) { 'random' }
    let(:creator_id) { 'random' }

    describe '#find_by' do
      subject(:find_by) { user.find_by(user_id: user_id, creator_id: creator_id) }

      let!(:status_request) do
        stub_request(:get, 'https://api.esignatur.dk/user/get/random')
          .and_return(
            body: File.read('spec/fixtures/user_response.json'),
            status: response_status_code
          )
      end

      let(:response_status_code) { 200 }

      it 'makes esignatur status request' do
        find_by
        expect(status_request).to have_been_made
      end

      context 'when request is not successfull' do
        let(:response_status_code) { 500 }

        it 'does not update attributes' do
          expect { find_by }.not_to change(user, :attributes)
        end
      end

      context 'when request is successfull' do
        it 'updates attributes' do
          expect { find_by }.to change(user, :attributes)
        end
      end
    end
  end
end
