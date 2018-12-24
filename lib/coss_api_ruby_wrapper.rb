# frozen_string_literal: true

require 'coss_api_ruby_wrapper/version'
require 'coss_api_ruby_wrapper/params_validations'
require 'coss_api_ruby_wrapper/exchange'
require 'net/http'
require 'net/https'
require 'json'
require 'openssl'

module CossApiRubyWrapper
  TRADE_HOST_URL = 'https://trade.coss.io/c/api/v1'
  ENGINE_HOST_URL = 'https://engine.coss.io/api/v1'
end
