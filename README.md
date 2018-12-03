# Esignatur


[![Build Status](https://travis-ci.org/samesystem/esignatur.svg?branch=master)](https://travis-ci.org/samesystem/esignatur)
[![codecov](https://codecov.io/gh/samesystem/esignatur/branch/master/graph/badge.svg)](https://codecov.io/gh/samesystem/esignatur)
[![Documentation](https://readthedocs.org/projects/ansicolortags/badge/?version=latest)](https://samesystem.github.io/esignatur)

https://api.esignatur.dk api ruby client

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'esignatur'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install esignatur

## Usage

```ruby
esignatur = Esignatur::Client.new(api_key: your_api_key)

esignatur.orders.where(modified_since: Date.new(2000, 1, 1))

order = esignatur.orders.find(esignatur_order_id)

order = esignatur.orders.build
order.create(some_order_params) # creates order on esignatur side
order.status # returns Status object
order.cancel(creator_id: '123') # => true/false

pades = order.pades
pades.document_data # decoded body of the document
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/esignatur. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Esignatur project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/esignatur/blob/master/CODE_OF_CONDUCT.md).
