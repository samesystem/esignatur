# frozen_string_literal: true

require 'bundler/setup'

require 'simplecov'
SimpleCov.start do
  add_filter(/_spec.rb\Z/)
end

require 'esignatur'
require 'webmock/rspec'

if ENV['CODECOV_TOKEN']
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require 'pry-byebug'

WebMock.disable_net_connect!(allow: ['codeclimate.com'])

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random
end
