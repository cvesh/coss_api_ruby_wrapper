# CossApiRubyWrapper

API wrapper for trading on cryptocurrency exchange [coss.io](https://coss.io/c/reg?r=BDMG5L7K9J)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'coss_api_ruby_wrapper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install coss_api_ruby_wrapper

## Usage

```ruby
coss = CossApiRubyWrapper::Exchange.new(public_key: 'YourPublicKey', private_key: 'YourPrivateKey')
coss.exchange_info # { ... }
```

### Exchange Instance Methods

|Method                 |Required Parameters | Optional Parameters| Notes   |
| --------------------- | ------------------ | ------------------ | ------- |
| place_limit_order     | symbol, price, side, amount| None |               |
| place_market_order    | symbol, price, side, amount| None |               |
| order_details         | order_id | None |                                 |
| trade_detail          | order_id | None |                                 |
| open_orders           | symbol | limit, page |                            |
| completed_orders      | symbol | limit, page |                            |
| all_orders            | symbol, from_order_id | limit |                   |
| cancel_order          | symbol, order_id | None |                         |
| market_price          | symbol | None |                                   |
| pair_depth            | symbol | None |                                   |
| market_summary        | symbol | None | Not implemented on COSS side      |
| exchange_info         | None | None |                                     |
| ping                  | None | None |                                     |
| time                  | None | None |                                     |
| account_balances      | None | None |                                     |
| account_details       | None | None |                                     |

### Errors

In case if invalid request parameters were supplied, error of class `CossApiRubyWrapper::ParamsValidations::InvalidParameter` will be thrown with text indicating specific parameters.

In case if request was sent but response status was not 200 OK, next hash will be provided:

```ruby
{
    status: 400,
    error: 'Invalid request'
}
```

error may contain any string: Error text, JSON object, or HTML page.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CossApiRubyWrapper project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ablebeam/coss_api_ruby_wrapper/blob/master/CODE_OF_CONDUCT.md).
