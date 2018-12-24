# frozen_string_literal: true

module CossApiRubyWrapper
  class Exchange
    attr_accessor :recv_window

    def initialize(public_key:, private_key:, recv_window: 5000)
      @public_key = public_key
      @private_key = private_key
      @recv_window = recv_window
    end

    def place_limit_order(symbol, price, side, amount)
      request(:post, '/order/add', order_symbol: symbol.to_s.strip, order_price: price.to_f, order_side: side.to_s.strip, order_size: amount.to_f, type: 'limit')
    end

    def place_market_order(symbol, price, side, amount)
      request(:post, '/order/add', order_symbol: symbol.to_s.strip, order_price: price.to_f, order_side: side.to_s.strip, order_size: amount.to_f, type: 'market')
    end

    def order_details(order_id)
      request(:post, '/order/details', order_id: order_id.to_s.strip)
    end

    def trade_detail(order_id)
      request(:post, '/order/trade-detail', order_id: order_id.to_s.strip)
    end

    def open_orders(symbol, limit = 10, page = 0)
      request(:post, '/order/list/open', limit: limit.to_i, page: page.to_i, symbol: symbol.to_s.strip)
    end

    def completed_orders(symbol, limit = 10, page = 0)
      request(:post, '/order/list/completed', limit: limit.to_i, page: page.to_i, symbol: symbol.to_s.strip)
    end

    def all_orders(symbol, from_order_id, limit = 10)
      request(:post, '/order/list/all', symbol: symbol.to_s.strip, from_id: from_order_id.to_s.strip, limit: limit.to_i)
    end

    def cancel_order(symbol, order_id)
      request(:delete, '/order/cancel', order_id: order_id.to_s.strip, order_symbol: symbol.to_s.strip)
    end

    # public request
    def market_price(symbol)
      request(:get, '/market-price', symbol: symbol.to_s.strip)
    end

    # public request
    def pair_depth(symbol)
      request(:get, '/dp', symbol: symbol.to_s.strip)
    end

    # public request
    def market_summary(symbol)
      request(:get, '/getmarketsummaries', symbol: symbol.to_s.strip)
    end

    # public request
    def exchange_info
      request(:get, '/exchange-info')
    end

    def ping
      request(:get, '/ping')
    end

    def time
      request(:get, '/time')
    end

    def account_balances
      request(:get, '/account/balances')
    end

    def account_details
      request(:get, '/account/details')
    end

    private

    def timestamp
      Time.now.to_i * 1000
    end

    def request(method, endpoint, params = {})
      validate!(endpoint, params)

      uri = URI("#{host_url(endpoint)}#{endpoint}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      params = normalized_params(params, endpoint)

      # GET requests parameters are passed only as URL address params and POST/DELETE requests require JSON parameters
      payload = method == :get ? URI.encode_www_form(params) : params.to_json
      request_path = method == :get ? [uri.path, payload].join('?') : uri.path

      req = Net::HTTP.const_get(method.capitalize).new(request_path, 'Content-Type': 'application/json', 'X-Requested-With': 'XMLHttpRequest')
      if private_request?(endpoint)
        req['Authorization'] = @public_key
        req['Signature'] = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @private_key, payload)
      end
      req.body = payload unless method == :get # Do not set payload inside request body for GET requests - use URL address parameters
      response = http.request(req)

      # Return error for both: JSON and HTML formats
      unless response.code == '200'
        return { status: response.code, error: (begin
                                                  JSON.parse(response.body)
                                                rescue StandardError
                                                  response.body
                                                end) }
      end

      JSON.parse(response.body)
    end

    def validate!(endpoint, params)
      # Run request parameters validations
      validations = ParamsValidations.new(endpoint, params)
      validations.run!
      raise CossApiRubyWrapper::ParamsValidations::InvalidParameter, validations.errors.join("\n") unless validations.errors.empty?
    end

    def normalized_params(params, endpoint)
      if private_request?(endpoint)
        params[:recvWindow] = recv_window.to_i
        params[:timestamp] = timestamp
      end
      # Some COSS endpoints require params to be sorted alphabetically
      Hash[params.sort_by(&:first)]
    end

    def host_url(endpoint)
      # At this point COSS has different hosts for some endpoints
      case endpoint
      when %r{^\/market_price.*}, %r{^\/dp.*}
        ENGINE_HOST_URL
      else
        TRADE_HOST_URL
      end
    end

    def private_request?(endpoint)
      # Public requqests are not required to be signed with public/private keys
      case endpoint
      when %r{^\/market-price.*}, %r{^\/dp.*/, /^\/exchange-info.*}, %r{^\/getmarketsummaries.*}, %r{^\/ping.*}, %r{^\/time.*}
        false
      else
        true
      end
    end
  end
end
